class Admin::UsersController < AdminController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_path, notice: 'The new user has been added.'
    else
      flash[:error] = 'There was an error adding the user.'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_path, notice: 'User has been updated..'
    else
      flash[:error] = 'There was an error updating the user.'
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_path, notice: 'The user has been deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :name, :password, :is_admin, :distance_units)
  end
end
