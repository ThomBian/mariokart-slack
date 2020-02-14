module Factory
  class BlockActions
    include Concern::HasPayloadParsing

    def initialize(params)
      @params = params
    end

    def build
      case block_action_id
      when ::Action::CreateGame::BUTTON_ACTION_ID
        ::Action::ShowSaveScoreModal.new(@params)
      else
        raise 'Unsupported block actions id'
      end
    end
  end
end