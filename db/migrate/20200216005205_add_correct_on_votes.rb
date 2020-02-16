class AddCorrectOnVotes < ActiveRecord::Migration[6.0]
  def change
    add_column :votes, :correct, :boolean, default: false
  end
end
