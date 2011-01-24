class TracksController < ApplicationController
  def show
    @track = Track.find(params[:id])
    @trackpoints = @track.trackpoints

    respond_to do |format|
      format.html
      format.gpx do
        filename = "track-#{@track.id}.gpx"
        headers["Content-Disposition"] = %{Content-Disposition: attachment; filename="#{filename}"}
      end
    end
  end

  def distance_elevation_data
    @track = Track.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @track.distance_elevation_data
      end
    end
  end

  def edit
    @track = Track.find(params[:id])
    @trackpoints = @track.trackpoints
  end

  def split
    @track = Track.find(params[:id])
    @trackpoint = Trackpoint.find(params[:trackpoint_id])

    unless @trackpoint.track == @track
      redirect_to log_track_path(@track.log, @track) and return
    end

    if @trackpoint == @track.trackpoints.first
      redirect_to log_track_path(@track.log, @track) and return
    end

    @new_track = @track.log.tracks.create
    @track.trackpoints.update_all({ :track_id => @new_track.id }, ["time >= ?", @trackpoint.time])

    @track.update_cached_information
    @new_track.update_cached_information

    redirect_to log_track_path(@new_track.log, @new_track)
  end

  def destroy
    @track = Track.find(params[:id])
    @log = @track.log
    @track.destroy

    redirect_to @log
  end
end
