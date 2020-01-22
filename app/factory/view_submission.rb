module Factory
  class ViewSubmission
    include Concern::HasPayload

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when ::Command::New::MODAL_ID
        ::Action::SubmitScoreView.new(@params)
      else
        raise 'Unsupported modal id'
      end
    end

    private

    def view_callback_id
      payload['view']['callback_id']
    end
  end
end
