class CreateTrackpoints < ActiveRecord::Migration
  def self.up
    create_table :trackpoints do |t|
      t.integer   :track_id
      t.float     :latitude, :null => false
      t.float     :longitude, :null => false
      t.float     :elevation
      t.datetime  :time, :null => false
    end
  end

  def self.down
    drop_table :trackpoints
  end
end
