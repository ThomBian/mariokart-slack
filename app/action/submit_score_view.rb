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
      players_usernames = usernames(game_results)

      create_new_players(new_players(players_usernames))
      # use data to compute new player elos
      player_elos = player_elos_lookup(players_usernames)
      puts "current elos: #{player_elos}"

      new_elos = compute_from(game_results, player_elos)
      # save new elos
      save_new_elos(new_elos)

      # send a recap of the game
      post_game_summary(game)
    end

    private

    def values
      @values ||= payload["view"]['state']['values']
    end

    def usernames(game_results)
      @usernames ||= game_results.map {|x| x[:username]}
    end

    def create_new_players(usernames)
      usernames.each do |username|
        ::Player.new(username: username).save!
      end
    end

    def new_players(usernames)
      usernames - ::Player.all.pluck(:username)
    end

    def player_elos_lookup(usernames)
      @elo ||= Player.where(username: usernames).select(:username, :elo).index_by(&:username)
    end

    def post_game_summary(game)
      Slack::Client.post_message(
        [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "A game has just been saved :mario-luigi-dance:"
            }
          },
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: game_summary_text(game)
            }
          }
        ]
      )
    end

    def game_summary_text(game)
      game.summary.map do |result|
        "#{result[:rank]}. <@#{result[:username]}>"
      end.join("\n")
    end
  end
end
