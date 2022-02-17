class Player < ActiveRecord::Base
  include Concern::Extensions::Player::Slack
  include Concern::Extensions::Player::Stats
  include Concern::Extensions::Player::Money
  include Concern::Extensions::Player::Vote

  has_many :games_players, class_name: '::GamesPlayers'
  has_many :games, through: :games_players, class_name: '::Game'
  has_many :players_achievements, class_name: '::PlayersAchievements', dependent: :destroy
  has_many :achievements, through: :players_achievements, class_name: '::Achievement'
  has_many :votes, class_name: '::Vote', foreign_key: 'voted_by_id'
  has_many :players_money_options, class_name: '::PlayersMoneyOptions'
  has_many :money_options, through: :players_money_options, class_name: '::MoneyOption'
  belongs_to :user, class_name: '::Player'

  scope :ordered_by_elo, -> { order(elo: :desc) }
  scope :with_rank, -> { active.select('*, RANK() OVER (ORDER BY elo DESC) rank_value') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def is_new?
    games.saved.none?
  end

  def name
    return display_name unless display_name.nil? || display_name.empty?
    return real_name unless real_name.nil? || real_name.empty?
    'No name'
  end

  def slack_username
    "<@#{username}>"
  end

  def name_with_achievements
    displayed_achievements = last_season_achievements.map {|a| a.emoji }.join(' ')
    [slack_username, displayed_achievements].reject(&:empty?).join(' ')
  end

  def last_season_achievements
    achievements.where(players_achievements: {season: Season.current.id - 1 })
  end

  def save_elo!(elo)
    self.highest_elo = elo if elo > (self.highest_elo || 0)
    self.lowest_elo = elo if elo < (self.lowest_elo || Float::INFINITY)
    self.elo = elo
    save!
  end

  # @see https://www.aceodds.com/bet-calculator/odds-converter.html
  def odds_to_win_against(players)
    1 / chance_to_win_against(players)
  end

  # @see https://stats.stackexchange.com/a/66398
  # @see "https://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details"
  def chance_to_win_against(players)
    qs = [self, players].flatten.map {|p| 10.pow(p.private_elo/400.0)}
    qs[0].to_f / qs.flatten.sum
  end

  def last_game
    games.order(created_at: :desc).first
  end

  def should_be_inactive?
    return true if last_game.nil?
    last_game.created_at < 2.weeks.ago
  end

  def set_inactive!
    update! active: false
  end

  def set_active!
    update! active: true
  end

  def self.players_rank
    Player.with_rank.index_by(&:id)
  end
end
