class LogsController < ApplicationController
  def index
    @logs = Log
      .joins(:tracks)
      .order("tracks.start_time DESC")
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

  def plot_data
    @log = Log.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @log.plot_data
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
