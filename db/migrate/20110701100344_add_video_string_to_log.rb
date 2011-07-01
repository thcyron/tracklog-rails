class AddVideoStringToLog < ActiveRecord::Migration
  def change
    add_column :logs, :video_url, :string
  end
end
