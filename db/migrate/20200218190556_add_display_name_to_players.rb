class AddDisplayNameToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :display_name, :text
    add_column :players, :display_name_last_set_at, :datetime
  end
end
