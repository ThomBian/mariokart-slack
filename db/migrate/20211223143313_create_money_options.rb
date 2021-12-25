class CreateMoneyOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :money_options do |t|
      t.text :title
      t.integer :value
      t.float :price

      t.boolean :active

      t.timestamps
    end

    create_table :players_money_options do |t|
      t.bigint :player_id
      t.bigint :money_option_id

      t.timestamps
    end

    add_index :players_money_options, :player_id
    add_index :players_money_options, :money_option_id
  end
end
