xml.instruct!

xml.gpx :xmlns => "http://www.topografix.com/GPX/1/1",
        :creator => "Bikelog",
        :version => "1.1" do
  xml.trk do
    xml.name @log.name

    @log.tracks.each do |track|
      xml.trkseg do
        track.trackpoints.each do |trackpoint|
          xml.trkpt :lat => trackpoint.latitude, :lon => trackpoint.longitude do
            xml.ele trackpoint.elevation if trackpoint.elevation
            xml.time trackpoint.time.xmlschema
          end
        end
      end
    end
  end
end
