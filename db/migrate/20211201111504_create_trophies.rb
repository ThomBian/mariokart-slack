class CreateTrophies < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.string :name
      t.string :emoji

      t.timestamps
    end

    create_table :players_achievements do |t|
      t.references :achievement, index: true
      t.references :player, index: true

      t.timestamps
    end
  end
end
