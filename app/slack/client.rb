module Slack
  class Client
    delegate :token, :views_open, :chat_postMessage, to: :api

    def initialize(token)
      @token = token
    end

    def api
      @api ||= Slack::Web::Client.new(token: @token)
    end

    def self.post_message(text: nil, blocks: nil)
      return false unless text.present? || blocks.present?
      layout = blocks.present? ?  blocks : default_blocks(text)

      @client  = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
      response = @client.chat_postMessage({
        token:   @client.token,
        channel: ENV['CHANNEL_ID'],
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
