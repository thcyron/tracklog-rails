class IndexTrackpointsOnTrackId < ActiveRecord::Migration
  def change
    add_index :trackpoints, :track_id
  end
end
