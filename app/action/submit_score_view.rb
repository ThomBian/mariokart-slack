module Action
  class SubmitScoreView
    include Concern::HasPayload
    include Concern::Elo
    include Serializer::Elo

    def initialize(params)
      @params = params
    end

    # change execution flow
    def process
      # format data from the form
      game = Concern::Game.new(values)
      game_results = game.results

      # use data to compute new player elos
      player_elos = player_elos_lookup(player_usernames(game_results))
      puts "current elos: #{player_elos}"
      new_elos = compute_from(game_results, player_elos)
      # save new elos
      save_new_elos(new_elos)

      # send a recap of the game
      game.summary
    end

    private

    def values
      @values ||= payload["view"]['state']['values']
    end

    def player_usernames(game_results)
      @player_usernames ||= game_results.map {|x| x[:username]}
    end

    def player_elos_lookup(usernames)
      return @elo if defined? @elo
      @elo = {}
      usernames.each do |player|
        @elo[player] = rand(800..1200)
      end
      @elo
    end
  end
end
