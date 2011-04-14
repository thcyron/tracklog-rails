class AlterTracksSpeedColumns < ActiveRecord::Migration
  def self.up
    rename_column :tracks, :average_speed, :overall_average_speed
    add_column :tracks, :moving_average_speed, :float

    Track.all.each { |t| t.update_cached_information }
  end

  def self.down
    rename_column :tracks, :overall_average_speed, :average_speed
    remove_column :tracks, :moving_average_speed
  end
end
