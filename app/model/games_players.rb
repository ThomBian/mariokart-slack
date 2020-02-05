class GamesPlayers < ActiveRecord::Base
  belongs_to :game, class_name: '::Game'
  belongs_to :player, class_name: '::Player'

  scope :with_rank_by_score, -> {select('*, RANK() OVER (ORDER BY score DESC) rank_value')}
end