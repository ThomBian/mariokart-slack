class Player < ActiveRecord::Base

  def to_s
    "#{slack_username} (#{elo})"
  end

  def slack_username
    "<@#{username}>"
  end
end