class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= session[:username] && User.find_by_username(session[:username])
  end

  def logged_in?
    !!current_user
  end

  def authenticate
    unless logged_in?
      if cookies.signed[:remember_me]
        username, salt = cookies.signed[:remember_me]

        if user = User.find_by_username(username)
          user_salt = BCrypt::Password.new(user.password_digest).salt

          if user_salt == salt
            @current_user = user
            @current_user.update_attribute(:last_login_at, Time.now)
          end
        end
      end

      unless logged_in?
        session[:return_to] = request.fullpath
        redirect_to login_path and return
      end
    end
  end
  protected :authenticate
end
