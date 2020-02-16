class Player < ActiveRecord::Base
  has_many :games_players, class_name: '::GamesPlayers'
  has_many :games, through: :games_players, class_name: '::Game'

  scope :ordered_by_elo, -> { order(elo: :desc) }
  scope :with_rank, -> { select('*, RANK() OVER (ORDER BY elo DESC) rank_value') }

  def is_new?
    games.saved.none?
  end

  def slack_username
    "<@#{username}>"
  end

  def save_elo!(elo)
    self.highest_elo = elo if elo > (self.highest_elo || 0)
    self.lowest_elo = elo if elo < (self.lowest_elo || Float::INFINITY)
    self.elo = elo
    save!
  end

  def get_or_load_small_avatar
    save_small_avatar(get_small_avatar_from_api) if need_to_save_small_avatar?
    small_avatar_url
  end

  def save_small_avatar(new_avatar)
    update! small_avatar_url: new_avatar, small_avatar_url_last_set_at: Time.now
  end

  def get_small_avatar_from_api
    client = Slack::Client.new(ENV['BOT_ACCESS_TOKEN'])
    response = client.users_info(user: username)
    return nil unless response['ok']
    response['user']['profile']['image_24']
  end

  def need_to_save_small_avatar?
    small_avatar_url.blank? || small_avatar_url_last_set_at > 1.months.ago
  end
end