class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

module Tracklog
  def self.haversine(lat1, lat2, lon1, lon2)
    r = 6371
    dlat = (lat2 - lat1).to_rad
    dlon = (lon2 - lon1).to_rad

    a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.cos(lat1.to_rad) * Math.cos(lat2.to_rad) * Math.sin(dlon / 2) * Math.sin(dlon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    r * c * 1000
  end
end
