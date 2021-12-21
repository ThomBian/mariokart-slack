class AddMoneyAddedAt < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :money_last_added_at, :datetime
  end
end
