class AdminController < ApplicationController
  before_filter :authenticate
  before_filter :check_admin_permissions

  def index
    @users = User.all
  end

  def check_admin_permissions
    unless current_user.is_admin?
      redirect_to dashboard_path and return
    end
  end
  private :check_admin_permissions
end
