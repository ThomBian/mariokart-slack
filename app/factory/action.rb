module Factory
  class Action
    include Concern::HasPayload

    def initialize(params)
      @params = params
    end

    def build
      case action_type
      when 'view_submission'
        Factory::ViewSubmission.new(@params).build
      when 'block_actions'
        Factory::BlockActions.new(@params).build
      when 'view_closed'
        Factory::ViewClosed.new(@params).build
      else
        raise "Unsupported action type #{action_type}"
      end
    end

    private

    def action_type
      payload['type']
    end
  end
end
