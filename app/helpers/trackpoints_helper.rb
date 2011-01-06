# encoding: utf-8

module TrackpointsHelper
  def format_coordinates(latitude, longitude)
    parts = []

    parts << (latitude > 0 ? "N" : "S")
    parts << "%.2d°" % latitude.abs.to_i

    minutes = (latitude.abs - latitude.abs.to_i) * 60
    parts << "%.2d.%.3d" % [minutes.to_i , ((minutes - minutes.to_i) * 1000).round]

    parts << (longitude > 0 ? "E" : "W")
    parts << "%.3d°" % longitude.abs.to_i

    minutes = (longitude.abs - longitude.abs.to_i) * 60
    parts << "%.2d.%.3d" % [minutes.to_i , ((minutes - minutes.to_i) * 1000).round]

    raw parts.join("&nbsp;")
  end
end
