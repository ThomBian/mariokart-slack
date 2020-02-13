module Action
  class CancelGame
    include ::Concern::HasPayload

    def initialize(params)
      @params = params
    end

    def process
      game.destroy
    end

    private

    def game
      @game ||=  Game.find(payload['view']['private_metadata'])
    end
  end
end