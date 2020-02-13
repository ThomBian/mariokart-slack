class AddStatusOnGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :status, :text, null: false, default: :draft
    add_index :games, :status
  end
end
