# encoding: utf-8

class TracksController < ApplicationController
  before_filter :authenticate
  before_filter :find_track_and_check_permission, except: [:create]

  def show
    @trackpoints = @track.trackpoints

    respond_to do |format|
      format.html

      format.json do
        render :json => [{
          :name => @track.display_name,
          :points => @trackpoints.map { |trackpoint|
            {
              :latitude  => trackpoint.latitude,
              :longitude => trackpoint.longitude,
              :elevation => trackpoint.elevation,
              :timestamp => trackpoint.time.to_i,
              :time      => trackpoint.time.strftime("%d.%m.%Y %H:%M")
            }
          }
        }]
      end

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

  def create
    @log = current_user.logs.find(params[:log_id])

    if params[:track_file]
      @log.create_tracks_from_gpx(params[:track_file].read)
    end

    redirect_to @log
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

    index = @track.trackpoints.index(@trackpoint)

    if index < 2 or index == (@track.trackpoints.size - 1)
      flash[:error] = "Splitting would result in tracks with less than 2 trackpoints"
      redirect_to log_track_trackpoints_path(@track.log, @track) and return
    end

    @new_track = @track.log.tracks.create
    @track.trackpoints.update_all({ :track_id => @new_track.id }, ["time >= ?", @trackpoint.time])

    @track.reload.update_cached_information
    @new_track.update_cached_information

    redirect_to log_track_path(@new_track.log, @new_track)
  end

  def transfer
    logs_by_year = {}

    Log.for_user(current_user).each do |log|
      year = log.start_time ? log.start_time.year : 0
      logs_by_year[year] ||= []
      logs_by_year[year] << log
    end

    @logs = logs_by_year.sort.map do |year, logs|
      logs.sort! do |a, b|
        a.start_time <=> b.start_time
      end

      [year, logs.map { |log|
        [log.name, log.id]
      }]
    end

    @logs[0] = ["Logs without tracks", @logs.first[1]] if @logs.first.first == 0

    if request.post?
      log = if not params[:transfer_log_id].blank?
        Log.for_user(current_user).find(params[:transfer_log_id])
      elsif not params[:transfer_log_name].blank?
        log = Log.new

        log.name = params[:transfer_log_name]
        log.user = current_user

        log.save ? log : nil
      end

      if log
        @track.log = log
        @track.set_relative_id

        if @track.save
          flash[:notice] = "The track has been transfered to log “#{log.name}”"
          redirect_to log_path(log)
        else
          flash[:error] = "Transfer failed"
        end
      end
    end
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
    @track = Track \
      .preload(:log)
      .where(:log_id => params[:log_id])
      .where(:relative_id => params[:id])
      .first!

    unless @track.log.user_id == current_user.id
      flash[:error] = "You don’t have permission to view this track."
      redirect_to dashboard_path and return
    end
  end
  private :find_track_and_check_permission
end
