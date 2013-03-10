class AddUniqueIndexToTracksOnLogIdAndRelativeId < ActiveRecord::Migration
  def change
    add_index :tracks, [:log_id, :relative_id], unique: true
  end
end
