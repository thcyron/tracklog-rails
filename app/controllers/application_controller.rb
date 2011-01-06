class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate, :if => lambda {
    Bikelog::Config.password and not Rails.env.development? and not Rails.env.test?
  }

  def authenticate
    authenticate_or_request_with_http_basic "Bikelog" do |username, password|
      password == Bikelog::Config.password
    end
  end
  private :authenticate
end
