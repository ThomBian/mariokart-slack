class AddBetOnVote < ActiveRecord::Migration[6.1]
  def change
    add_column :votes, :bet, :float
  end
end
