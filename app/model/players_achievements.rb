class PlayersAchievements < ActiveRecord::Base
    belongs_to :achievement, class_name: '::Achievement'
    belongs_to :player, class_name: '::Player'
    belongs_to :season, class_name: '::Season'
end  