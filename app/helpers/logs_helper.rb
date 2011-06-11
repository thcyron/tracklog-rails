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

    if current_user.distance_units == :imperial
      raw("#{distance_in_meters.to_miles.round(2)}&nbsp;miles")
    else
      raw("#{distance_in_meters.to_kilometers.round(2)}&nbsp;km")
    end
  end

  def format_speed(speed_in_meters_per_second)
    speed_in_meters_per_second ||= 0

    if current_user.distance_units == :imperial
      raw("#{speed_in_meters_per_second.to_miles_per_hour.round(2)}&nbsp;mph")
    else
      raw("#{speed_in_meters_per_second.to_kilometers_per_hour.round(2)}&nbsp;km/h")
    end
  end

  def format_elevation(elevation_in_meters)
    elevation_in_meters ||= 0

    if current_user.distance_units == :imperial
      raw("#{elevation_in_meters.to_feet.round}&nbsp;ft")
    else
      raw("#{elevation_in_meters.round}&nbsp;m")
    end
  end
end
