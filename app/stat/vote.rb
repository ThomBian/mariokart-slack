module Stat
  class Vote<Base
    def title
      ':crystal_ball: Correct votes:'
    end

    def value
      ::Vote.where(voted_by: @player, correct: true).count
    end
  end
end