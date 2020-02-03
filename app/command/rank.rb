module Command
  class Rank
    RANK_TO_EMOJI = {
      1 => ':first_place_medal:',
      2 => ':second_place_medal:',
      3 => ':third_place_medal:',
      4 => ':sum:',
    }

    def initialize(params: nil)
      @params = params
    end

    def process
      ::Slack::Client.post_direct_message(blocks: blocks, users: user)
    end

    def rank_of_the_day
      ::Slack::Client.post_message(blocks: blocks)
    end

    private

    def blocks
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": ":fleur_de_lis: *RANKING* :fleur_de_lis:"
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
        rank_value = player.rank_value <= 4 ? "#{RANK_TO_EMOJI[player.rank_value]}": "#{player.rank_value}.  "
         "#{rank_value} #{player.slack_username} (#{player.elo})"
      end.join("\n")
    end

    def user
      @params['user_id']
    end
  end
end