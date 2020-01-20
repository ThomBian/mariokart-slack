module Slack
  class Client
    delegate :token, :views_open, to: :api

    def api
      @api ||= Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    end
  end
end
