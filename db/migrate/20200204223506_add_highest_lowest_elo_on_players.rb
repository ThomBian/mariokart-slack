class AddHighestLowestEloOnPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :highest_elo, :integer
    add_column :players, :lowest_elo, :integer
  end
end
