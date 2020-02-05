class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.column :created_by_id, :integer

      t.timestamps
    end

    create_table :games_players do |t|
      t.references :game, index: true
      t.references :player, index: true

      t.column :score, :integer, null: false

      t.timestamps
    end

    add_index(:games_players, [:game_id, :player_id], unique: true)
  end
end
