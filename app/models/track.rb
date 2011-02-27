class Track < ActiveRecord::Base
  belongs_to :log
  has_many :trackpoints, :order => "time ASC", :dependent => :destroy

  def update_cached_information
    self.start_time = self.trackpoints.first.time
    self.end_time   = self.trackpoints.last.time
    self.duration   = self.end_time - self.start_time

    calculate_min_max_elevation
    calculate_distance_max_speed_ascent_descent

    if self.distance and self.distance > 0 and self.duration > 0
      self.average_speed = self.distance / self.duration
    else
      self.average_speed = 0
    end

    save
  end

  def calculate_min_max_elevation
    self.min_elevation = nil
    self.max_elevation = nil

    self.trackpoints.each do |trackpoint|
      self.min_elevation ||= trackpoint.elevation
      self.max_elevation ||= trackpoint.elevation

      self.max_elevation = trackpoint.elevation if trackpoint.elevation > self.max_elevation
      self.min_elevation = trackpoint.elevation if trackpoint.elevation < self.min_elevation
    end
  end
  private :calculate_min_max_elevation

  def calculate_distance_max_speed_ascent_descent
    self.distance   = 0
    self.ascent     = 0
    self.descent    = 0
    self.max_speed  = 0

    0.upto(self.trackpoints.size - 2) do |i|
      tp1 = self.trackpoints[i]
      tp2 = self.trackpoints[i + 1]

      self.distance += tp1.distance_to_trackpoint(tp2)
      speed          = tp1.speed_to_trackpoint(tp2)
      ascent         = tp1.ascent_to_trackpoint(tp2)

      self.max_speed = speed if speed > self.max_speed
      self.ascent   += ascent if ascent > 0
      self.descent  -= ascent if ascent < 0
    end
  end
  private :calculate_distance_max_speed_ascent_descent

  def plot_data
    trackpoints = self.trackpoints
    return [] if trackpoints.size.zero?

    data    = []
    distance = 0

    data << {
      :distance   => 0.0,
      :speed      => 0.0,
      :elevation  => trackpoints.first.elevation,
      :latitude   => trackpoints.first.latitude,
      :longitude  => trackpoints.first.longitude
    }

    1.upto(trackpoints.size - 2) do |i|
      tp1 = trackpoints[i]
      tp2 = trackpoints[i + 1]

      distance += tp1.distance_to_trackpoint(tp2)

      data << {
        :distance   => distance,
        :speed      => tp1.speed_to_trackpoint(tp2),
        :elevation  => tp2.elevation,
        :latitude   => tp2.latitude,
        :longitude  => tp2.longitude
      }
    end

    data
  end
end
