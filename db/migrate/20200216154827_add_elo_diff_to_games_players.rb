class AddEloDiffToGamesPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :games_players, :elo_diff, :integer
  end
end
