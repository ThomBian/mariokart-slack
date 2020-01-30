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
      game = Concern::Game.new(values, created_by)
      game_results = game.results
      players_usernames = usernames(game_results)

      create_new_players(new_players(players_usernames))
      # use data to compute new player elos
      player_elos = player_elos_lookup(players_usernames)
      new_elos = compute_from(game_results, player_elos)

      # save new elos
      save_new_elos(new_elos)

      # send a recap of the game
      post_game_summary(game)
    end

    private

    def created_by
      @created_by ||= payload['user']['id']
    end

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

    def save_new_elos(new_elos)
      new_elos.each do |new_elo|
        player = ::Player.find_by(username: new_elo[:username])
        player.update! elo: new_elo[:value]
      end
    end

    def post_game_summary(game)
      Slack::Client.post_message(
        [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": ":mario-luigi-dance: A game has just been saved by <@#{game.created_by}>"
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
        emoji = Command::Rank::RANK_TO_EMOJI[result[:rank]]
        "#{emoji} <@#{result[:username]}> #{emoji_from_score(result[:score])}"
      end.join("\n")
    end

    def emoji_from_score(score)
      return ':star2:' if score == 60
      return ':ligue1:' if score >= 35
      return ':ligue2:' if score >= 30
      ':unacceptable:'
    end
  end
end
