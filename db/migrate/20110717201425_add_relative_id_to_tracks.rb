class AddRelativeIdToTracks < ActiveRecord::Migration
  def up
    add_column :tracks, :relative_id, :integer

    Log.all.each do |log|
      id = 1

      log.tracks.each do |track|
        track.update_attribute(:relative_id, id)
        id += 1
      end
    end

    change_column :tracks, :relative_id, :integer, :null => false
  end

  def down
    remove_column :tracks, :relative_id
  end
end
