class TracksController < ApplicationController
  def show
    @track = Track.find(params[:id])
    @trackpoints = @track.trackpoints

    respond_to :html, :gpx
  end

  def destroy
    @track = Track.find(params[:id])
    @log = @track.log
    @track.destroy

    redirect_to @log
  end
end
