require "ostruct"
require "bikelog/core_ext"

Bikelog::Config = OpenStruct.new

# Unit for distances: :metric or :imperial
Bikelog::Config.distance_units = :metric
