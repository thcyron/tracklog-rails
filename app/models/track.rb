class Track < ActiveRecord::Base
  require 'net/http'
  require 'open-uri'
  require 'json'

  belongs_to :log
  has_many :trackpoints, order: "time ASC", dependent: :destroy

  scope :for_user, ->(user) { joins(:log).where("logs.user_id = ?", user.id) }

  def display_name
    if self.name and self.name.strip.length > 0
      self.name
    else
      "Track #{self.id}"
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
end
