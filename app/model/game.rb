class Game < ActiveRecord::Base
  extend Enumerize

  belongs_to :created_by, class_name: '::Player'
  has_many :games_players, class_name: '::GamesPlayers'
  has_many :players, through: :games_players, class_name: '::Player'


  accepts_nested_attributes_for :games_players

  enumerize :status, in: [:draft, :saved]
  scope :draft, -> { where(status: :draft) }
  scope :saved, -> { where(status: :saved) }
end
