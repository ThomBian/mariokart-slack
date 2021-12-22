class AddRealNameOnPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :real_name, :text
  end
end
