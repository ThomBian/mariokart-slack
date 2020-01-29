module Command
  class Rank
    RANK_TO_EMOJI = {
      1 => ':first_place_medal:',
      2 => ':second_place_medal:',
      3 =>':third_place_medal:',
      4 => ':flag-be:',
    }

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
        rank_value = player.rank_value <= 4 ? RANK_TO_EMOJI[player.rank_value] : player.rank_value
         "#{rank_value}. #{player.slack_username} (#{player.elo})"
      end.join("\n")
    end
  end
end