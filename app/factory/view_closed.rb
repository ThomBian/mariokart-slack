module Factory
  class ViewClosed
    include ::Concern::HasPayloadParsing

    def initialize(params)
      @params = params
    end

    def build
      case view_callback_id
      when ::Action::ShowSaveScoreModal::CALLBACK_ID
        ::Action::CancelGame.new(@params)
      else
        raise "Unsupported close view callback id: #{view_callback_id}"
      end
    end
  end
end