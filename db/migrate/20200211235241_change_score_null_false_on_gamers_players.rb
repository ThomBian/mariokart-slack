class ChangeScoreNullFalseOnGamersPlayers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :games_players, :score, true
  end
end
