class PlayersAchievements < ActiveRecord::Base
    belongs_to :achievement, class_name: '::Achievement'
    belongs_to :player, class_name: '::Player'
end  