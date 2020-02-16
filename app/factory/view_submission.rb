module Factory
  class ViewSubmission
    include Concern::HasPayloadParsing

    SAVE_SCORE_CALLBACK_ID = 'save_score_submission'
    NEW_CALLBACK_ID = 'create_game'

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when NEW_CALLBACK_ID
        ::Action::CreateGame.new(@params)
      when SAVE_SCORE_CALLBACK_ID
        ::Action::SaveScore.new(@params)
      else
        raise 'Unsupported modal id'
      end
    end
  end
end
