class RemoveRelativeIdFromTracks < ActiveRecord::Migration
  def up
    remove_index :tracks, [:log_id, :relative_id]
    remove_column :tracks, :relative_id
  end
end
