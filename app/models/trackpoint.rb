require "bikelog/haversine"

class Trackpoint < ActiveRecord::Base
  belongs_to :track

  validates :latitude,  :presence => true, :numericality => true
  validates :longitude, :presence => true, :numericality => true
  validates :elevation,                    :numericality => true
  validates :time,      :presence => true

  def distance_to_trackpoint(trackpoint)
    Bikelog.haversine(self.latitude, trackpoint.latitude, self.longitude, trackpoint.longitude)
  end

  def time_to_trackpoint(trackpoint)
    (trackpoint.time - self.time).abs
  end

  def speed_to_trackpoint(trackpoint)
    distance_to_trackpoint(trackpoint).to_f / time_to_trackpoint(trackpoint).to_f
  end

  def ascent_to_trackpoint(trackpoint)
    trackpoint.elevation - self.elevation
  end
end
