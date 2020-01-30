class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.column :created_by, :text, null: false
      t.datetime :created_at
    end
  end
end
