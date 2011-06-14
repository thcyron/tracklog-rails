class AuthController < ApplicationController
  before_filter :authenticate, :except => [:login]
  layout nil, :only => [:login]

  def login
    redirect_to dashboard_path and return if logged_in?

    if request.post?
      if user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
        return_to = session[:return_to]
        reset_session

        session[:username] = user.username
        @current_user = user
        @current_user.update_attribute(:last_login_at, Time.now)

        salt = BCrypt::Password.new(current_user.password_digest).salt
        cookies.signed[:remember_me] = {
          :value => [current_user.username, salt],
          :expires => 2.weeks.from_now.utc
        }

        redirect_to return_to || dashboard_path
      else
        flash[:error] = "Wrong username or password"
      end
    end
  end

  def logout
    reset_session
    cookies.signed[:remember_me] = nil
    redirect_to login_path
  end
end
