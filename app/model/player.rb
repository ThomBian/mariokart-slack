class Player < ActiveRecord::Base
  has_many :games_players, class_name: '::GamesPlayers'
  has_many :games, through: :games_players, class_name: '::Game'
  has_many :players_achievements, class_name: '::PlayersAchievements', dependent: :destroy
  has_many :achievements, through: :players_achievements, class_name: '::Achievement'
  has_many :votes, class_name: '::Vote', foreign_key: 'voted_by_id'

  scope :ordered_by_elo, -> { order(elo: :desc) }
  scope :with_rank, -> { active.select('*, RANK() OVER (ORDER BY elo DESC) rank_value') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def is_new?
    games.saved.none?
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

  def get_or_load_small_avatar
    save_small_avatar(get_profile_from_api['image_24']) if need_to_save_small_avatar?
    small_avatar_url
  end

  def get_or_load_display_name
    display_name unless need_to_save_display_name?
    name = get_profile_from_api['display_name']
    name = get_profile_from_api['real_name'] if name.blank?
    save_display_name(name)
    display_name
  end

  # @see https://www.aceodds.com/bet-calculator/odds-converter.html
  def odds_to_win_against(players)
    1 / chance_to_win_against(players)
  end

  # @see https://stats.stackexchange.com/a/66398
  # @see "https://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details"
  def chance_to_win_against(players)
    qs = [self, players].flatten.map {|p| 10.pow(p.elo/400.0)}
    qs[0].to_f / qs.flatten.sum
  end

  def last_game
    games.order(created_at: :desc).first
  end

  def should_be_inactive?
    last_game.created_at < 2.weeks.ago
  end

  def set_inactive!
    update! active: false
  end

  def set_active!
    update! active: true
  end

  def update_money!(vote)
    update money: money + vote.earnings
  end

  def has_already_voted?(game)
    votes.where(game: game).any?
  end

  def current_rank
    return -1 unless active?
    Player.with_rank.index_by(&:id)[id].rank_value
  end

  def elo_history
    gps = games_players.current_season.where('elo_diff IS NOT NULL').order('created_at DESC')
    
    elos = gps.pluck(:elo_diff).inject([elo]) do |memo, elo_diff|
      previous_elo = memo[-1]
      elo = previous_elo - elo_diff
      memo << elo
      memo
    end

    [Time.now, gps.pluck(:created_at)].flatten.map{|x| x.strftime("%Y-%m-%d %H:%M:%S")}.zip(elos).reverse()
  end

  private

  def save_small_avatar(new_avatar)
    update! small_avatar_url: new_avatar, small_avatar_url_last_set_at: Time.now
  end

  def save_display_name(new_display_name)
    update! display_name: new_display_name, display_name_last_set_at: Time.now
  end

  def get_profile_from_api
    return @response if defined? @response
    client = Slack::Client.new
    response = client.users_info(user: username)
    return nil unless response['ok']
    @response = response['user']['profile']
  end

  def need_to_save_small_avatar?
    small_avatar_url.blank? || small_avatar_url_last_set_at.blank? || small_avatar_url_last_set_at > 1.months.ago
  end

  def need_to_save_display_name?
    display_name.blank? || display_name_last_set_at.blank? || display_name_last_set_at > 1.months.ago
  end
end
