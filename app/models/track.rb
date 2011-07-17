class Track < ActiveRecord::Base
  belongs_to :log
  has_many :trackpoints, :order => "time ASC", :dependent => :destroy
  attr_accessible :name

  scope :for_user, lambda { |user|
    joins(:log).where("logs.user_id = ?", user.id)
  }

  before_create :set_relative_id

  def to_param
    self.relative_id.to_s
  end

  def display_name
    if self.name and self.name.strip.length > 0
      self.name
    else
      "Track #{self.relative_id}"
    end
  end

  def self.total_duration
    sum(:duration)
  end

  def self.total_distance
    sum(:distance)
  end

  def update_cached_information
    self.start_time = self.trackpoints.first.time
    self.end_time   = self.trackpoints.last.time
    self.duration   = self.end_time - self.start_time

    calculate_min_max_elevation
    calculate_distance_max_speed_ascent_descent

    if self.distance and self.distance > 0 and self.duration > 0
      self.overall_average_speed = self.distance / self.duration

      if self.moving_time > 0
        self.moving_average_speed = self.distance / self.moving_time
      else
        self.moving_average_speed = 0
      end
    else
      self.overall_average_speed = 0
      self.moving_average_speed = 0
    end

    save
  end

  def calculate_min_max_elevation
    self.min_elevation = nil
    self.max_elevation = nil

    self.trackpoints.each do |trackpoint|
      if trackpoint.elevation
        self.min_elevation ||= trackpoint.elevation
        self.max_elevation ||= trackpoint.elevation

        self.max_elevation = trackpoint.elevation if trackpoint.elevation > self.max_elevation
        self.min_elevation = trackpoint.elevation if trackpoint.elevation < self.min_elevation
      end
    end
  end
  private :calculate_min_max_elevation

  def calculate_distance_max_speed_ascent_descent
    self.distance     = 0
    self.ascent       = 0
    self.descent      = 0
    self.max_speed    = 0
    self.moving_time  = 0
    self.stopped_time = 0

    0.upto(self.trackpoints.size - 2) do |i|
      tp1 = self.trackpoints[i]
      tp2 = self.trackpoints[i + 1]

      self.distance += tp1.distance_to_trackpoint(tp2)
      speed          = tp1.speed_to_trackpoint(tp2)
      ascent         = tp1.ascent_to_trackpoint(tp2)
      time           = tp1.time_to_trackpoint(tp2)
      self.max_speed = speed if speed > self.max_speed

      if ascent
        self.ascent  += ascent if ascent > 0
        self.descent -= ascent if ascent < 0
      end

      if speed > 0.5.kilometer_per_hour
        self.moving_time += time
      else
        self.stopped_time += time
      end
    end
  end
  private :calculate_distance_max_speed_ascent_descent

  def set_relative_id
    last_track = self.log.tracks.order("id DESC").first
    self.relative_id = last_track ? last_track.relative_id + 1 : 1
  end

  def plot_data
    trackpoints = self.trackpoints
    return [] if trackpoints.size.zero?

    points   = []
    distance = 0

    points << {
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

      points << {
        :distance   => distance,
        :speed      => tp1.speed_to_trackpoint(tp2),
        :elevation  => tp2.elevation,
        :latitude   => tp2.latitude,
        :longitude  => tp2.longitude
      }
    end

    {
      :min_elevation => self.min_elevation,
      :points => points
    }
  end
end
