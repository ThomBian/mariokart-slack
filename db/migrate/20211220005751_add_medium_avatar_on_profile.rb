class AddMediumAvatarOnProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :medium_avatar_url, :text
    add_column :players, :medium_avatar_url_last_set_at, :datetime
  end
end
