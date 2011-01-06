xml.instruct!

xml.gpx :xmlns => "http://www.topografix.com/GPX/1/1",
        :creator => "Bikelog",
        :version => "1.1" do
  xml.metadata do
    xml.name @track.log.name
    xml.time Time.now.xmlschema
  end

  xml.trk do
    xml.name "Track #{@track.id}"
    xml.trkseg do
      @trackpoints.each do |trackpoint|
        xml.trkpt :lat => trackpoint.latitude, :lon => trackpoint.longitude do
          xml.ele trackpoint.elevation if trackpoint.elevation
          xml.time trackpoint.time.xmlschema
        end
      end
    end
  end
end
