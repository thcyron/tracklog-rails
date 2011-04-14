class AddTracksMovingAndStoppedTime < ActiveRecord::Migration
  def self.up
    add_column :tracks, :moving_time, :float
    add_column :tracks, :stopped_time, :float

    Track.all.each { |t| t.update_cached_information }
  end

  def self.down
    remove_column :tracks, :moving_time
    remove_column :tracks, :stopped_time
  end
end
