class AddOddOnGamesPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :games_players, :odd, :float
  end
end
