module Slack
  class Client
    delegate :token, :views_open, :chat_postMessage, :conversations_open, :chat_postEphemeral, :chat_delete, :users_info, to: :api

    def initialize
      @token = ENV['BOT_ACCESS_TOKEN']
    end

    def api
      @api ||= Slack::Web::Client.new(token: @token)
    end

    def self.post_direct_message(text: nil, blocks: nil, users: nil)
      return false unless users.present?

      client  = Slack::Client.new
      response = client.conversations_open({token: client.token, users: users})
      return false unless response['ok']

      channel_id = response['channel']['id']
      post_message(text: text, blocks: blocks, channel_id: channel_id)
    end

    def self.post_message(text: nil, blocks: nil, channel_id: nil)
      return false unless text.present? || blocks.present?

      client  = Slack::Client.new
      layout = blocks.present? ?  blocks : default_blocks(text)
      response = client.chat_postMessage({
        token:   client.token,
        channel: channel_id || ENV['CHANNEL_ID'],
        blocks: layout
      })
      response['ok']
    end

    def self.delete_message(ts: nil)
      return false unless ts.present?

      client  = Slack::Client.new
      response = client.chat_delete(ts: ts, channel: ENV['CHANNEL_ID'])
      response['ok']
    end

    def self.post_ephemeral_message(text: '', blocks: nil, user:, channel_id:)
      client  = Slack::Client.new
      response = client.chat_postEphemeral({
        token: client.token,
        channel: channel_id,
        user: user,
        blocks: blocks || default_blocks(text)
      })
      response['ok']
    end

    private

    def self.default_blocks(text)
      [{
        type: "section",
        text: {
          type: "mrkdwn",
          text: text
        }
      }]
    end
  end
end
