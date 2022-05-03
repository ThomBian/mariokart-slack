class AddEloToGamesPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :games_players, :elo, :float, default: 0
  end
end
