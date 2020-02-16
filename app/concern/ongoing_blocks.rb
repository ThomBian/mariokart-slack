module Concern
  module OngoingBlocks

    def ongoing_blocks(game)
      [
          {
              "type": "section",
              "text": {
                  "type": "mrkdwn",
                  "text": "*Who's gonna win this game?*"
              }
          },
          {"type": "divider"},
          vote_lines(game),
          {
              "type": "actions",
              "elements": [{
                               "type": "button",
                               "text": {
                                   "type": "plain_text",
                                   "text": "Save score ✅",
                                   "emoji": true
                               },
                               "style": "primary",
                               "value": game.id.to_s,
                               "action_id": ::Factory::BlockActions::BUTTON_ACTION_ID
                           }]
          }
      ].flatten
    end

    private

    def vote_lines(game)
      game.games_players.includes(:player, :votes).map do |game_player|
        [vote_line(game_player), vote_line_context(game_player), {"type": "divider"}]
      end
    end

    def vote_line(game_player)
      stats_line = game_player.player.is_new? ? ':new: New player' : stats(game_player)
      chance_to_win_line = "Chance to win the game: #{chance_to_win(game_player)}"
      {
          "type": "section",
          "text": {
              "type": "mrkdwn",
              "text": "*#{game_player.player.slack_username}*\n#{stats_line}\n#{chance_to_win_line}"
          },
          "accessory": {
              "type": "button",
              "text": {
                  "type": "plain_text",
                  "emoji": true,
                  "text": "Vote"
              },
              "value": "#{game_player.id}",
              "action_id": ::Factory::BlockActions::VOTE_ACTION_ID
          }
      }
    end

    def chance_to_win(game_player)
      player = game_player.player
      other_players = game_player.game.players - [player]
      player.chance_to_win_against(other_players)*100.0.to_i
    end

    STATS = [::Stat::Rank, ::Stat::Elo::Current]
    def stats(game_player)
      STATS.map {|s| s.new(game_player.player).markdown}.join(' | ')
    end

    def vote_line_context(game_player)
      {
          "type": "context",
          "elements": [
              avatars(game_player.votes),
              {
                  "type": "plain_text",
                  "emoji": true,
                  "text": vote_string(game_player.votes.count)
              }
          ].flatten
      }
    end

    def vote_string(votes_count)
      return 'No votes' if votes_count == 0
      return '1 vote' if votes_count == 1
      "#{votes_count} votes"
    end

    def avatars(votes)
      votes.map do |vote|
        {
            "type": "image",
            "image_url": vote.voted_by.get_or_load_small_avatar,
            "alt_text": "avatar of a player"
        }
      end
    end
  end
end