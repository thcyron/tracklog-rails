class TrackpointsController < ApplicationController
  def destroy
    @trackpoint = Trackpoint.find(params[:id])
    @track = @trackpoint.track
    @trackpoint.destroy

    redirect_to [@track.log, @track]
  end
end
