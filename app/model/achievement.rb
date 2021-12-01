class Achievement < ActiveRecord::Base
  has_many :players_achievements, class_name: '::PlayersAchievement', dependent: :destroy
  has_many :players, through: :players_achievements, class_name: '::Player'
end