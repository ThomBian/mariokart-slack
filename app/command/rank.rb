module Command
  class Rank
    include Concern::Date

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
      return if weekend?
      ::Slack::Client.post_message(blocks: blocks(false))
    end

    private

    def blocks(from_command = true)
      [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": from_command ? personal_ranking_title : today_ranking_title
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

    def personal_ranking_title
      ":fleur_de_lis: *RANKING* :fleur_de_lis:"
    end

    def today_ranking_title
      ":drum_with_drumsticks::drum_with_drumsticks::drum_with_drumsticks: *TODAY'S RANKING* :drum_with_drumsticks::drum_with_drumsticks::drum_with_drumsticks:"
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