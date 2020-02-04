module Command
  class Help
    def initialize(params:)
      @params = params
    end

    def process
      ::Slack::Client.post_ephemeral_message(blocks: blocks, channel_id: channel_id, user: user)
    end

    private

    def blocks
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "Here is how I work.\n" +
                      "Type `/mariokart new` to save a new game \n" +
                      "Type `/mariokart rank` to see the actual ranking \n" +
                      "Type `/mariokart my-stats`` to see your in game stats"
          }
        }
      ]
    end

    def user
      @params['user_id']
    end

    def channel_id
      @params['channel_id']
    end
  end
end