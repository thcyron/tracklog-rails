# encoding: utf-8

class TracksController < ApplicationController
  before_filter :authenticate
  before_filter :find_track_and_check_permission

  def show
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
    respond_to do |format|
      format.json do
        track_plot_data = @track.plot_data

        render :json => {
          :minElevation => track_plot_data[:min_elevation],
          :points => track_plot_data[:points]
        }
      end
    end
  end

  def update
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
    @log = @track.log

    if @log.tracks.size == 1
      flash[:error] = "You can’t delete the only track of a log."
      redirect_to log_track_path(@log, @track)
    else
      @track.destroy
      redirect_to log_path(@log)
    end
  end

  def find_track_and_check_permission
    @track = Track.preload(:log).find(params[:id])

    unless @track.log.user_id == current_user.id
      flash[:error] = "You don’t have permission to view this track."
      redirect_to dashboard_path and return
    end
  end
  private :find_track_and_check_permission
end
