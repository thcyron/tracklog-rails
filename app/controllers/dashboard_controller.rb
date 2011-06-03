class DashboardController < ApplicationController
  def index
    @total_distance   = Track.total_distance
    @total_duration   = Track.total_duration
    @total_logs_count = Log.count

    @last_log = Log \
      .joins(:tracks) \
      .order("tracks.start_time DESC") \
      .first

    @this_month = Time.now.beginning_of_month
    @next_month = @this_month + 1.month

    @total_distance_this_month = Track \
      .where("start_time >= ?", @this_month) \
      .where("start_time < ?", @next_month) \
      .sum(:distance)

    @total_duration_this_month = Track \
      .where("start_time >= ?", @this_month) \
      .where("start_time < ?", @next_month) \
      .sum(:duration)

    @logs_count_this_month = Log \
      .select("logs.id") \
      .joins(:tracks) \
      .where("tracks.start_time >= ?", @this_month) \
      .where("tracks.start_time < ?", @next_month) \
      .uniq \
      .count

    @this_year = Time.now.beginning_of_year
    @next_year = @this_year + 1.year
    @last_year = @this_year - 1.year

    @total_distance_this_year = Track \
      .where("start_time >= ?", @this_year) \
      .where("start_time < ?", @next_year) \
      .sum(:distance)

    @total_duration_this_year = Track \
      .where("start_time >= ?", @this_year) \
      .where("start_time < ?", @next_year) \
      .sum(:duration)

    @logs_count_this_year = Log \
      .joins(:tracks) \
      .where("start_time >= ?", @this_year) \
      .where("start_time < ?", @next_year) \
      .uniq \
      .count

    @total_distance_last_year = Track \
      .where("start_time >= ?", @last_year) \
      .where("start_time < ?", @this_year) \
      .sum(:distance)

    @total_duration_last_year = Track \
      .where("start_time >= ?", @last_year) \
      .where("start_time < ?", @this_year) \
      .sum(:duration)

    @logs_count_last_year = Log \
      .joins(:tracks) \
      .where("start_time >= ?", @last_year) \
      .where("start_time < ?", @this_year) \
      .uniq \
      .count
  end

  def activity_plots_data
    @last_12_months_activity = {}
    this_month = Time.now.beginning_of_month

    0.upto(11) do |i|
      @last_12_months_activity[this_month - i.months] = {
        :distance => 0.0,
        :duration => 0.0,
      }
    end

    Track.where("start_time >= ?", this_month - 11.months).each do |track|
      time = Time.mktime(track.start_time.year, track.start_time.month)
      @last_12_months_activity[time][:distance] += track.distance
      @last_12_months_activity[time][:duration] += track.duration
    end

    respond_to do |format|
      format.json do
        render :json => @last_12_months_activity.to_a \
        .sort{ |a,b| b[0] <=> a[0] } \
        .map { |d, a|
          {
            :month => d.strftime("%b"),
            :distance => a[:distance],
            :duration => a[:duration]
          }
        }
      end
    end
  end
end
