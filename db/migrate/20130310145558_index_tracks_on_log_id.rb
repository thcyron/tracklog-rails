class IndexTracksOnLogId < ActiveRecord::Migration
  def change
    add_index :tracks, :log_id
  end
end
