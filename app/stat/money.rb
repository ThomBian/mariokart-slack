module Stat
    class Money < Base
        def title
            emoji = @player.money >= 0 ? ':moneybag:' : ':rotating_light:'
            "#{emoji} Money:"
          end
      
          def value
            "#{@player.money.round(2)} $Պ"
          end
    end
end