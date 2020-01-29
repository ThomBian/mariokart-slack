module Command
  class Rank
    def process
      ::Slack::Client.post_message(blocks)
    end

    private

    def blocks
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "Ranking season 1"
          }
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: ranking_text
          }
        }
      ]
    end

    def ranking_text
      Player.with_rank.ordered_by_elo.map do |player|
         "#{player.rank_value}. #{player.slack_username} (#{player.elo})"
      end.join("\n")
    end
  end
end