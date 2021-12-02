class CreateSeason < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons do |t|
      t.boolean :is_current, default: false

      t.timestamps
    end

    add_column :games, :season_id, :bigint
    add_column :players_achievements, :season_id, :bigint

    add_index :games, :season_id
    add_index :players_achievements, :season_id
  end
end
