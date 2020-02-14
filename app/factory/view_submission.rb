module Factory
  class ViewSubmission
    include Concern::HasPayloadParsing

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when ::Command::New::CALLBACK_ID
        ::Action::CreateGame.new(@params)
      when ::Action::ShowSaveScoreModal::CALLBACK_ID
        ::Action::SaveScore.new(@params)
      else
        raise 'Unsupported modal id'
      end
    end
  end
end
