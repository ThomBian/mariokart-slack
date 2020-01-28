class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.column :username, :text, null: false
      t.column :elo, :integer, default: 1000

      t.index :username, unique: true
    end
  end
end
