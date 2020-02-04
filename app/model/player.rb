class Player < ActiveRecord::Base

  scope :ordered_by_elo, -> { order(elo: :desc) }
  scope :with_rank, -> { select('*, RANK() OVER (ORDER BY elo DESC) rank_value') }

  def slack_username
    "<@#{username}>"
  end

  def save_elo!(elo)
    self.highest_elo = elo if elo > self.highest_elo
    self.lowest_elo = elo if elo < self.lowest_elo
    self.elo = elo
    save!
  end
end