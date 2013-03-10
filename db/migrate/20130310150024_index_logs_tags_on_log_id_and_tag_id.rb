class IndexLogsTagsOnLogIdAndTagId < ActiveRecord::Migration
  def change
    add_index :logs_tags, [:log_id, :tag_id], unique: true
  end
end
