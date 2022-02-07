module Command
    class Rematch
        def initialize(params: nil)
            @params = params
        end

        def process
            ::Action::CreateGame.new(players: players, params: @params).process
        end

        private

        def players
            Game.saved.last.players
        end
    end
end