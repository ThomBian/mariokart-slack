class AddPrivateElo < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :private_elo, :integer, default: 1000
  end
end
