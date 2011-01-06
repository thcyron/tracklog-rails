class DashboardController < ApplicationController
  def index
    @total_distance = Log.total_distance
    @total_duration = Log.total_duration
    @logs_count     = Log.count
  end
end
