module Action
  class SubmitScoreView
    include Concern::HasPayload
    include Lib::Elo

    def initialize(params)
      @params = params
    end

    # change execution flow
    def process
      # format data from the form
      save_new_elos(new_elos_by_username(game_results, players))

      # send a recap of the game
      game = Game.create!({
        created_by:               created_by,
        games_players_attributes: games_players_attributes
      })

      game.post_summary
    end

    private

    def save_new_elos(new_elos)
      players.each do |player|
        player.save_elo!(new_elos[player.username])
      end
    end

    def game_results
      @results ||= (1..nb_players).map do |player_index|
        {
          username: values["player_#{player_index}"]["username_#{player_index}"]['selected_user'],
          score:    values["score_input_#{player_index}"]["score_value_#{player_index}"]['value'].to_i
        }
      end
    end

    def nb_players
      @nb_players ||= values.keys.map {|x| x[-1]}.uniq.max.to_i
    end

    def values
      @values ||= payload["view"]['state']['values']
    end

    def created_by
      @created_by ||= Player.find_by(username: payload['user']['id'])
    end

    def games_players_attributes
      score_by_username = game_results.index_by { |x| x[:username] }
      players.map { |p| {player: p, score: score_by_username[p.username][:score]} }
    end

    def players
      @players ||= game_results.map do |result|
        Player.find_or_create_by(username: result[:username])
      end
    end
  end
end
