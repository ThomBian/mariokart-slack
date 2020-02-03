module Slack
  class Client
    delegate :token, :views_open, :chat_postMessage, :conversations_open, to: :api

    def initialize(token)
      @token = token
    end

    def api
      @api ||= Slack::Web::Client.new(token: @token)
    end

    def self.post_direct_message(text: nil, blocks: nil, users: nil)
      return false unless users.present?
      @client  = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
      response = @client.conversations_open({token: @client.token, users: users})
      return false unless response['ok']
      channel_id = response['channel']['id']
      post_message(text: text, blocks: blocks, channel_id: channel_id)
    end

    def self.post_message(text: nil, blocks: nil, channel_id: nil)
      return false unless text.present? || blocks.present?
      layout = blocks.present? ?  blocks : default_blocks(text)

      @client  = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
      response = @client.chat_postMessage({
        token:   @client.token,
        channel: channel_id || ENV['CHANNEL_ID'],
        blocks: layout
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
