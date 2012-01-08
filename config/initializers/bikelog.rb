require "ostruct"
require "tracklog/core_ext"

Tracklog::Config = OpenStruct.new

# Unit for distances: :metric or :imperial
Tracklog::Config.distance_units = :metric
