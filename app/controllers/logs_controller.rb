# encoding: utf-8

class LogsController < ApplicationController
  before_filter :authenticate
  before_filter :find_log_and_check_permission, :except => [:index, :new, :create]

  def index
    @selected_year = params[:year] ? params[:year].to_i : Time.now.year

    @logs = Log \
      .for_user(current_user) \
      .joins(:tracks) \
      .where("tracks.start_time >= ? AND tracks.start_time < ?",
        Time.mktime(@selected_year, 1, 1), Time.mktime(@selected_year + 1, 1, 1)) \
      .order("tracks.start_time ASC") \
      .uniq

    @total_distance = 0.0
    @total_duration = 0.0
    @logs_by_months = {}

    @logs.each do |log|
      @total_distance += log.distance
      @total_duration += log.duration

      time = Time.mktime(@selected_year, log.start_time.month, 1)

      @logs_by_months[time] ||= {
        :logs => [],
        :total_distance => 0.0,
        :total_duration => 0.0
      }

      @logs_by_months[time][:logs] << log
      @logs_by_months[time][:total_distance] += log.distance
      @logs_by_months[time][:total_duration] += log.duration
    end
  end

  def show
    respond_to do |format|
      format.html
      format.gpx do
        filename = "log-#{@log.id}-#{@log.name.parameterize}.gpx"
        headers["Content-Disposition"] = %{Content-Disposition: attachment; filename="#{filename}"}
      end
    end
  end

  def plot_data
    respond_to do |format|
      format.json do
        log_plot_data = @log.plot_data

        render :json => {
          :minElevation => log_plot_data[:min_elevation],
          :points => log_plot_data[:points]
        }
      end
    end
  end

  def tracks
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
    @log.user = current_user

    unless @log.save
      render :action => :new and return
    end

    if params[:log][:track_file]
      @log.create_tracks_from_gpx(params[:log][:track_file].read)
    end

    redirect_to @log
  end

  def edit
    @orig_log = @log.dup
  end

  def update
    @orig_log = @log.dup

    if @log.update_attributes(params[:log])
      redirect_to @log
    else
      flash[:error] = "There was an error updating the log."
      render :edit
    end
  end

  def destroy
    @log.destroy
    redirect_to @log
  end

  def find_log_and_check_permission
    @log = Log.find(params[:id])

    unless @log.user_id == current_user.id
      flash[:error] = "You don’t have permission to view this log."
      redirect_to dashboard_path and return
    end
  end
  private :find_log_and_check_permission
end
