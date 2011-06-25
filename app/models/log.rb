class Log < ActiveRecord::Base
  belongs_to :user

  has_many :tracks, :order => "start_time ASC", :dependent => :destroy
  has_many :trackpoints, :through => :tracks

  attr_accessible :name, :comment
  validates :name, :presence => true

  scope :for_user, lambda { |user|
    where(:user_id => user.id)
  }

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

  def overall_average_speed
    @overall_average_speed ||= begin
      if distance > 0 and duration > 0
        distance / duration
      end
    end
  end

  def moving_average_speed
    @moving_average_speed ||= begin
      if distance > 0 and moving_time > 0
        distance / moving_time
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
    points = []
    min_elevation = nil

    self.tracks.each do |track|
      track_plot_data = track.plot_data

      if not min_elevation or min_elevation > track_plot_data[:min_elevation]
        min_elevation = track_plot_data[:min_elevation]
      end

      if points.size > 0
        distance = points.last[:distance]

        track_plot_data[:points].each do |datum|
          datum[:distance] += distance
        end
      end

      points += track_plot_data[:points]
    end

    {
      :min_elevation => min_elevation,
      :points => points
    }
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

    doc.xpath("/g:gpx/g:trk", "g" => ns).each do |trk|
      tracks = []

      # Track name
      nodes = trk.xpath("./g:name", "g" => ns)
      track_name = (nodes.size == 1) ? nodes.first.text : nil

      # Track Segments
      trkseg_nodes = trk.xpath("./g:trkseg", "g" => ns)
      trkseg_nodes.each_with_index do |trkseg, i|
        track = self.tracks.new
        trackpoints = []

        trkseg.xpath("./g:trkpt", "g" => ns).each do |trkpt|
          # Elevation
          nodes = trkpt.xpath("./g:ele", "g" => ns)
          elevation = (nodes.size == 1) ? nodes.first.text.to_f : nil

          # Time
          nodes = trkpt.xpath("./g:time", "g" => ns)
          time = (nodes.size == 1) ? Time.parse(nodes.first.text) : nil

          if time and trkpt["lat"] and trkpt["lon"]
            trackpoint = Trackpoint.new \
              :latitude  => trkpt["lat"],
              :longitude => trkpt["lon"],
              :elevation => elevation,
              :time      => time
            trackpoints << trackpoint
          end
        end

        if trackpoints.size > 2
          track.save

          trackpoints.each do |trackpoint|
            trackpoint.track = track
            trackpoint.save
          end

          track.update_cached_information
          tracks << track
        end
      end

      if track_name
        if tracks.size == 1
          tracks.first.update_attribute(:name, track_name)
        else
          tracks.each_with_index do |track, i|
            track.update_attribute(:name, "#{track_name} ##{i + 1}")
          end
        end
      end

      new_tracks += tracks
    end

    new_tracks
  end

  def rank
    @rank ||= begin
      if alternatives.count > 1
        logs = alternatives.map { |log| [log.id, log.duration] }
        logs.sort! { |a, b| a[1] <=> b[1] }

        if index = logs.map { |log| log.first }.index(self.id)
          return index + 1
        end
      end

      nil
    end
  end

  def alternatives
    @alternatives ||= Log.for_user(self.user).where(:name => self.name)
  end
end
