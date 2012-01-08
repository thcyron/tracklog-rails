class Numeric
  # Returns meter per second
  def kilometer_per_hour
    self / 3600.0 * 1000.0
  end

  def to_kilometers_per_hour
    self.to_kilometers * 3600.0
  end

  def to_miles_per_hour
    self.to_miles * 3600.0
  end

  def to_kilometers
    self / 1000.0
  end

  def to_miles
    self / 1609.344
  end

  def to_feet
    self / 0.3048
  end
end
