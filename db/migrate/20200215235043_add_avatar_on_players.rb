class AddAvatarOnPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :small_avatar_url, :text
    add_column :players, :small_avatar_url_last_set_at, :datetime
  end
end
