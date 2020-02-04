module Stat
  class Base
    def initialize(player)
      @player = player
    end

    def markdown
      "*#{self.title}:* #{self.value}"
    end

    def title
      ''
    end

    def value
      ''
    end
  end
end