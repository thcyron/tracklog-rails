# encoding: utf-8

class TracksController < ApplicationController
  def show
    @track = Track.find(params[:id])
    @trackpoints = @track.trackpoints

    respond_to do |format|
      format.html
      format.gpx do
        filename = if @track.name and @track.name.strip.length > 0
          "track-#{@track.id}-#{@track.name.parameterize}.gpx"
        else
          "track-#{@track.id}.gpx"
        end

        headers["Content-Disposition"] = %{Content-Disposition: attachment; filename="#{filename}"}
      end
    end
  end

  def plot_data
    @track = Track.find(params[:id])

    respond_to do |format|
      format.json do
        render :json => @track.plot_data
      end
    end
  end

  def update
    @track = Track.find(params[:id])

    if @track.update_attributes(params[:track])
      respond_to do |format|
        format.json do
          render :json => { :status => "success" },
                 :status => :ok
        end
      end
    else
      respond_to do |format|
        format.json do
          render :json => { :status => "error" },
                 :status => :unprocessable_entity
        end
      end
    end
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

    if @log.tracks.size == 1
      flash[:error] = "You can’t delete the only track of a log."
      redirect_to log_track_path(@log, @track)
    else
      @track.destroy
      redirect_to log_path(@log)
    end
  end
end
