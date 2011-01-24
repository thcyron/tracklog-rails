class LogsController < ApplicationController
  def index
    @logs = Log.all.sort do |a, b|
      if a.start_time and b.start_time
        b.start_time <=> a.start_time
      else
        0
      end
    end
  end

  def show
    @log = Log.find(params[:id])

    respond_to do |format|
      format.html
      format.gpx do
        filename = "log-#{@log.id}-#{@log.name.parameterize}.gpx"
        headers["Content-Disposition"] = %{Content-Disposition: attachment; filename="#{filename}"}
      end
    end
  end

  def distance_elevation_data
    @log = Log.find(params[:id])
    data = []

    @log.tracks.each do |track|
      track_data = track.distance_elevation_data

      if data.size > 0
        track_data.map! do |a|
          [a[0] + data.last[0], a[1]]
        end
      end

      data += track_data
    end

    respond_to do |format|
      format.json do
        render :json => data
      end
    end
  end

  def tracks
    @log = Log.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @log.tracks.map { |track|
          track.trackpoints.map do |trackpoint|
            [trackpoint.latitude, trackpoint.longitude]
          end
        }
      end
    end
  end

  def upload_track
    @log = Log.find(params[:id])

    if params[:track_file]
      @log.create_tracks_from_gpx(params[:track_file].read)
    end

    redirect_to @log
  end

  def new
    @log = Log.new
  end

  def create
    @log = Log.new(params[:log])

    unless @log.save
      render :action => :new and return
    end

    if params[:log][:track_file]
      @log.create_tracks_from_gpx(params[:log][:track_file].read)
    end

    redirect_to @log
  end

  def edit
    @log = Log.find(params[:id])
  end

  def update
    @log = Log.find(params[:id])

    if @log.update_attributes(params[:log])
      redirect_to @log
    end
  end

  def destroy
    @log = Log.find(params[:id])
    @log.destroy

    redirect_to @log
  end
end
