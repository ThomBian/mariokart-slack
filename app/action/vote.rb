module Action
  class Vote
    include ::Concern::HasPayloadParsing
    include ::Concern::OngoingBlocks
    include ::Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      return post_already_voted_message if voter.has_already_voted?(games_players.game)
      return not_enough_money_error if voter.money < bet

      ::Vote.create!({games_players: games_players, game: games_players.game, voted_by: voter, bet: bet})

      post_has_voted(games_players)
      response_ok_basic
    end

    private

    def voter 
      @voter ||= ::Player.find_or_create_by(username: command_sent_by_user_id)
    end

    def games_players
      @gp ||= ::GamesPlayers.find(private_metadata["game_player_id"].to_i)
    end

    def bet
      values[::Action::ShowSaveVoteModal::INPUT_ID][::Action::ShowSaveVoteModal::INPUT_ID]["value"].to_f
    end

    def post_already_voted_message
      Slack::Client.post_ephemeral_message(
          text: "You have already voted! :eyes:",
          user: command_sent_by_user_id,
          channel_id: ENV['CHANNEL_ID']
      )
      response_ok_basic
    end

    def not_enough_money_error
      body = {
        "response_action": "errors",
        "errors": {
          "#{ShowSaveVoteModal::INPUT_ID}": "You do not have enough money!"
        }
      }

      response_ok_with_body(body)
    end

    def post_has_voted(game_player)
      HTTParty.post(response_url, {
          body: {
              replace_original: true,
              blocks: ongoing_blocks(game_player.game)
          }.to_json,
          headers: {'Content-Type' => 'application/json'}
      })
    end

    def response_url
      # define in ShowSaveVoteModal#view_content
      private_metadata["response_url"]
    end
  end
end