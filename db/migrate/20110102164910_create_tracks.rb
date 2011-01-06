class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer   :log_id
      t.float     :distance
      t.float     :duration
      t.float     :average_speed
      t.float     :max_speed
      t.float     :ascent
      t.float     :descent
      t.float     :min_elevation
      t.float     :max_elevation
      t.datetime  :start_time
      t.datetime  :end_time
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
