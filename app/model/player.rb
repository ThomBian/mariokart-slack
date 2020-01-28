class Player < ActiveRecord::Base

  scope :ordered_by_elo, -> { order(elo: :desc) }
  scope :with_rank, -> { select('*, RANK() OVER (ORDER BY elo DESC) rank_value') }

  def slack_username
    "<@#{username}>"
  end
end