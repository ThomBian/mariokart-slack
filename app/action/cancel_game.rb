module Action
  class CancelGame
    include ::Concern::HasPayloadParsing
    include ::Concern::OngoingBlocks

    def initialize(params)
      @params = params
    end

    def process
      Slack::Client.post_message(blocks: ongoing_blocks(game))
    end

    private

    def game
      @game ||=  Game.find(private_metadata)
    end
  end
end
