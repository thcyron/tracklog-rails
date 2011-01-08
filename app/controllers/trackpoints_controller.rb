class TrackpointsController < ApplicationController
  def index
    if params[:track_id]
      @track = Track.find(params[:track_id])
      @trackpoints = @track.trackpoints

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

    if @trackpoint.destroy
      @track.update_cached_information
    end

    redirect_to log_track_path(@track.log, @track)
  end
end
