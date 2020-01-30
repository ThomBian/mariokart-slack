module Command
  class Help
    def process
      ::Slack::Client.post_message(blocks: blocks)
    end

    private

    def blocks
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "Here is how I work.\n Type `/mariokart new` to save a new game \n Type `/mariokart rank` to see the actual ranking"
          }
        }
      ]
    end
  end
end