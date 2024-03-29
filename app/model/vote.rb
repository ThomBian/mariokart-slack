class Vote < ActiveRecord::Base
  belongs_to :voted_by, class_name: '::Player'
  belongs_to :games_players, class_name: '::GamesPlayers'
  belongs_to :game, class_name: '::Game'

  scope :winners, -> { where(correct: true) }

  def earnings
    odd = games_players.odd
    return 0 unless correct
    odd * bet
  end
end