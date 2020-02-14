module Action
  class CancelGame
    include ::Concern::HasPayloadParsing

    def initialize(params)
      @params = params
    end

    def process
      game.destroy
    end

    private

    def game
      @game ||=  Game.find(private_metadata)
    end
  end
end