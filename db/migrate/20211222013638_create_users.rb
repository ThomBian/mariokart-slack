class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name

      t.timestamps
    end

    add_column :players, :user_id, :bigint
    add_index :players, :user_id
  end
end
