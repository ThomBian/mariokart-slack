class AddVoteMoneyOnPlayer < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :money, :float, default: 50
  end
end
