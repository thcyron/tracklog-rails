class Log < ActiveRecord::Base
  has_many :tracks, :order => "start_time ASC", :dependent => :destroy
  has_many :trackpoints, :through => :tracks

  attr_accessible :name, :comment
  validates :name, :presence => true

  def start_time
    @start_time ||= self.tracks.map { |t| t.start_time }.min
  end

  def end_time
    @end_time ||= self.tracks.map { |t| t.end_time }.max
  end

  def moving_time
    @moving_time ||= self.tracks.map { |t| t.moving_time }.sum
  end

  def stopped_time
    @stopped_time ||= self.tracks.map { |t| t.stopped_time }.sum
  end

  def duration
    @duration ||= self.tracks.inject(0) { |a, b| a + b.duration if b.duration }
  end

  def distance
    @distance ||= self.tracks.inject(0) { |a, b| a + b.distance if b.distance }
  end

  def average_speed
    @average_speed ||= begin
      if distance > 0 and duration > 0
        distance / duration
      end
    end
  end

  def max_speed
    @max_speed ||= self.tracks.map { |t| t.max_speed }.max
  end

  def ascent
    @ascent ||= self.tracks.map { |t| t.ascent }.sum
  end

  def descent
    @descent ||= self.tracks.map { |t| t.descent }.sum
  end

  def min_elevation
    @min_elevation ||= self.tracks.map { |t| t.min_elevation }.min
  end

  def max_elevation
    @max_elevation ||= self.tracks.map { |t| t.max_elevation }.max
  end

  def plot_data
    data = []

    self.tracks.each do |track|
      track_data = track.plot_data

      if data.size > 0
        distance = data.last[:distance]

        track_data.each do |datum|
          datum[:distance] += distance
        end
      end

      data += track_data
    end

    data
  end

  def self.total_duration
    all.inject(0) { |a, b| a + b.duration }
  end

  def self.total_distance
    all.inject(0) { |a, b| a + b.distance }
  end

  def self.total_average_speed
    if (dis = total_distance) > 0 and (dur = total_duration) > 0
      dis / dur
    end
  end

  def self.total_ascent
    all.inject(0) { |a, b| a + b.ascent }
  end

  def create_tracks_from_gpx(gpx)
    doc = Nokogiri::XML.parse(gpx)
    new_tracks = []
    ns = "http://www.topografix.com/GPX/1/1"

    doc.xpath("/g:gpx/g:trk/g:trkseg", "g" => ns).each do |trkseg|
      track = self.tracks.create

      trkseg.xpath("//g:trkpt", "g" => ns).each do |trkpt|
        elevation = trkpt.search("ele").text.to_f
        time = Time.parse(trkpt.search("time").text)

        track.trackpoints.create \
          :latitude  => trkpt["lat"],
          :longitude => trkpt["lon"],
          :elevation => elevation,
          :time      => time
      end

      track.update_cached_information
    end

    new_tracks
  end
end
