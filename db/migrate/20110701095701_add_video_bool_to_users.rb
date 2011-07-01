class AddVideoBoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :video_enabled, :boolean, :default => false
  end
end
