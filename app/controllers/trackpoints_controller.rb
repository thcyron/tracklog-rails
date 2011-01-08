class TrackpointsController < ApplicationController
  def destroy
    @trackpoint = Trackpoint.find(params[:id])
    @track = @trackpoint.track

    if @trackpoint.destroy
      @track.update_cached_information
    end

    redirect_to log_track_path(@track.log, @track)
  end
end
