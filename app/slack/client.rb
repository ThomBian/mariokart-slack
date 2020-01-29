module Slack
  class Client
    delegate :token, :views_open, :chat_postMessage, to: :api

    def initialize(token)
      @token = token
    end

    def api
      @api ||= Slack::Web::Client.new(token: @token)
    end

    def self.post_message(blocks)
      @client  = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
      response = @client.chat_postMessage({
        token:   @client.token,
        channel: ENV['CHANNEL_ID'],
        blocks: blocks
      })
      response['ok']
    end
  end
end
