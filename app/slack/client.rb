module Slack
  class Client
    delegate :token, :views_open, :chat_postMessage, to: :api

    def initialize(token)
      @token = token
    end

    def api
      @api ||= Slack::Web::Client.new(token: @token)
    end
  end
end
