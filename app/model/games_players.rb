class GamesPlayers < ActiveRecord::Base
  belongs_to :game, class_name: '::Game'
  belongs_to :player, class_name: '::Player'

  has_many :votes, class_name: '::Vote'

  scope :with_rank_by_score, -> { select('*, RANK() OVER (ORDER BY score DESC) rank_value') }
  scope :winners, -> { with_rank_by_score.select{|x| x.rank_value == 1} }
end