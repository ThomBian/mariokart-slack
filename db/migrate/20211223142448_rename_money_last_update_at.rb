class RenameMoneyLastUpdateAt < ActiveRecord::Migration[6.1]
  def change
    rename_column :players, :money_last_added_at, :last_free_money_added_at
  end
end
