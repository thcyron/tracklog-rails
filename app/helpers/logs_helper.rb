module LogsHelper
  def format_duration(duration_in_seconds)
    duration_in_seconds ||= 0

    hours   = duration_in_seconds / 3600
    minutes = duration_in_seconds % 3600 / 60
    seconds = duration_in_seconds % 60

    "%d:%.2d:%.2d" % [hours, minutes, seconds]
  end

  def format_distance(distance_in_meters)
    distance_in_meters ||= 0
    raw("#{(distance_in_meters / 1000).round(2)}&nbsp;km")
  end

  def format_speed(speed_in_meters_per_second)
    speed_in_meters_per_second ||= 0
    raw("#{(speed_in_meters_per_second / 1000 * 3600).round(2)}&nbsp;km/h")
  end

  def format_elevation(elevation_in_meters)
    elevation_in_meters ||= 0
    raw("#{elevation_in_meters.round}&nbsp;m")
  end
end
