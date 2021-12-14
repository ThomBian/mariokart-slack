module Action
  class CancelOngoingGame
    include Concern::HasPayloadParsing
    include Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      gp = Game.find(block_action_value.to_i)
      gp.destroy! unless gp.status == 'saved'

      ::Slack::Client.delete_message(ts: message_ts)
      response_ok_basic
    end
  end
end