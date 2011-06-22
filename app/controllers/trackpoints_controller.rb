# encoding: utf-8

class TrackpointsController < ApplicationController
  before_filter :authenticate

  def index
    if params[:track_id]
      @track = Track.preload(:log).find(params[:track_id])
      @trackpoints = @track.trackpoints

      check_permission @track.log or return

      @trackpoints_count = @trackpoints.size

      respond_to do |format|
        format.html
        format.json do
          render :json => [@trackpoints.map { |trackpoint|
            [trackpoint.latitude, trackpoint.longitude]
          }]
        end
      end
    end
  end

  def destroy
    @trackpoint = Trackpoint.find(params[:id])
    @track = @trackpoint.track

    check_permission @track.log or return

    if @track.trackpoints.size == 2
      flash[:error] = "A track needs at least two trackpoints"
      redirect_to log_track_trackpoints_path(@track.log, @track) and return
    end

    if @trackpoint.destroy
      @track.update_cached_information
    end

    redirect_to log_track_path(@track.log, @track)
  end

  def check_permission(log)
    if log.user_id == current_user.id
      true
    else
      flash[:error] = "You don’t have permission to view this track point."
      redirect_to dashboard_path
      false
    end
  end
  private :check_permission
end
