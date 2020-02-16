module Concern
  module GameSummaryBlocks
    def summary_blocks(game)
      [
          {
              "type": "section",
              "text": {
                  "type": "mrkdwn",
                  "text": ":mario-luigi-dance: :checkered_flag: *NEW GAME* :checkered_flag: :mario-luigi-dance:"
              },
          },
          {
              "type": "context",
              "elements": [
                  {
                      "type": "mrkdwn",
                      "text": "saved by #{game.created_by.slack_username}"
                  }
              ]
          },
          {
              type: "section",
              text: {
                  type: "mrkdwn",
                  text: summary_text(game)
              }
          },
          {type: 'divider'},
          {
              type: "section",
              text: {
                  type: "mrkdwn",
                  text: vote_text(game)
              }
          },
          {type: 'divider'}
      ]
    end

    private

    def summary_text(game)
      game.games_players.includes(:player).with_rank_by_score.map { |x| game_player_summary_line(x) }.join("\n")
    end

    def game_player_summary_line(game_player)
      emoji = Command::Rank::RANK_TO_EMOJI[game_player.rank_value]
      score_infos = "#{game_player.player.slack_username} #{score_to_emoji(game_player.score)}"
      elo_rank = elo_rank_lookup[game_player.player.username].rank_value
      elo_infos = ":fleur_de_lis: #{game_player.player.elo} (#{elo_rank})"
      "#{emoji} #{score_infos} - #{elo_infos} - #{elo_diff_text(game_player.elo_diff)}"
    end

    def elo_rank_lookup
      @elo_rank_lookup ||= Player.with_rank.index_by(&:username)
    end

    def score_to_emoji(score)
      return ':star2:' if score == 60
      return ':ligue1:' if score >= 35
      return ':ligue2:' if score >= 30
      ':unacceptable:'
    end

    def elo_diff_text(elo_diff)
      return ":arrow_up: #{elo_diff.abs} points" if elo_diff > 0
      return ":arrow_down: #{elo_diff.abs} points" if elo_diff < 0
      ":neutral_face: No elo changes"
    end

    def vote_text(game)
      users_with_correct_vote = ::Vote.includes(:voted_by).winners.where(games_players: game.games_players).map do |vote|
        vote.voted_by.slack_username
      end
      users_with_correct_vote.any? ? "List of correct voters: #{users_with_correct_vote.join(', ')}" : 'No voters were right on that one!'
    end
  end
end