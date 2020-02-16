class CreateVoteTable < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :games_players
      t.references :game

      t.column :voted_by_id, :integer

      t.timestamps
    end

    add_index :votes, [:games_players_id, :voted_by_id], unique: true
  end
end
