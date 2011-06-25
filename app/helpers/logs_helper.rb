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
      raw("#{number_with_delimiter distance_in_meters.to_miles.round(2)}&nbsp;miles")
    else
      raw("#{number_with_delimiter distance_in_meters.to_kilometers.round(2)}&nbsp;km")
    end
  end

  def format_short_distance(distance_in_meters)
    distance_in_meters ||= 0

    if current_user.distance_units == :imperial
      raw("#{number_with_delimiter distance_in_meters.to_feet.round(2)}&nbsp;ft")
    else
      raw("#{number_with_delimiter distance_in_meters.round(2)}&nbsp;m")
    end
  end

  def format_speed(speed_in_meters_per_second)
    speed_in_meters_per_second ||= 0

    if current_user.distance_units == :imperial
      raw("#{number_with_delimiter speed_in_meters_per_second.to_miles_per_hour.round(2)}&nbsp;mph")
    else
      raw("#{number_with_delimiter speed_in_meters_per_second.to_kilometers_per_hour.round(2)}&nbsp;km/h")
    end
  end

  def format_elevation(elevation_in_meters)
    elevation_in_meters ||= 0

    if current_user.distance_units == :imperial
      raw("#{number_with_delimiter elevation_in_meters.to_feet.round}&nbsp;ft")
    else
      raw("#{number_with_delimiter elevation_in_meters.round}&nbsp;m")
    end
  end
  
  def format_rank(rank)
    title = ['', 'Fastest Time', '2nd Fastest Time', '3rd Fastest Time']
    image_tag("rank_#{rank}.png", :title => title[rank]) unless rank == 0 or rank > 3
  end
end
