module Factory
  class ViewClosed
    include Concern::HasPayloadParsing

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when ::Factory::ViewSubmission::SAVE_SCORE_CALLBACK_ID
        ::Action::CancelGame.new(@params)
      else
        puts "Unsupported close view callback id: #{view_callback_id}"
      end
    end
  end
end