module Action
  class CancelGame
    include ::Concern::HasPayloadParsing
    include ::Concern::OngoingBlocks
    include ::Concern::ServerResponse

    def initialize(params)
      @params = params
    end

    def process
      Slack::Client.post_message(blocks: ongoing_blocks(game))
      response_ok_basic
    end

    private

    def game
      @game ||=  Game.find(private_metadata["game_id"])
    end
  end
end
