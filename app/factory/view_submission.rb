module Factory
  class ViewSubmission
    include Concern::HasPayloadParsing

    SAVE_SCORE_CALLBACK_ID = 'save_score_submission'
    SAVE_VOTE_CALLBACK_ID = 'save_vote_submission'
    NEW_CALLBACK_ID = 'create_game'

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when NEW_CALLBACK_ID
        ::Action::CreateGame.new(players: players, params: @params)
      when SAVE_SCORE_CALLBACK_ID
        ::Action::SaveScore.new(@params)
      when SAVE_VOTE_CALLBACK_ID
        ::Action::Vote.new(@params)
      else
        raise 'Unsupported modal id'
      end
    end

    private

    def players
      player_usernames_from_input.map {|username| Player.find_or_create_by(username: username)}
    end

    def player_usernames_from_input
      values["players_input"]["players_value"]["selected_users"]
    end
  end
end
