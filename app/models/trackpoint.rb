class Numeric
  def to_rad
    self * Math::PI / 180 
  end
end

class Trackpoint < ActiveRecord::Base
  belongs_to :track

  validates :latitude,  :presence => true, :numericality => true
  validates :longitude, :presence => true, :numericality => true
  validates :elevation,                    :numericality => true
  validates :time,      :presence => true

  def distance_to_trackpoint(trackpoint)
    haversine(self.latitude, trackpoint.latitude, self.longitude, trackpoint.longitude)
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

  def haversine(lat1, lat2, lon1, lon2)
    r = 6371
    dlat = (lat2 - lat1).to_rad
    dlon = (lon2 - lon1).to_rad

    a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(lat1.to_rad) * Math.cos(lat2.to_rad) * Math.sin(dlon / 2) * Math.sin(dlon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    r * c * 1000
  end
  private :haversine
end
