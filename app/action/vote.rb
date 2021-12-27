module Action
  class Vote
    include Concern::HasPayloadParsing
    include Concern::OngoingBlocks
    include Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      result = voter.vote(games_players, bet)
      return error_response(result[:message]) if(result[:error])

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

    def error_response(message)
      body = {
        "response_action": "errors",
        "errors": {
          "#{ShowSaveVoteModal::INPUT_ID}": message
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