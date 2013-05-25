class Admin::UsersController < AdminController
  def new
    @user = User.new
  end

  def create
    @user = User.new

    if @user.create(user_params)
      redirect_to admin_path, :notice => "The new user has been added."
    else
      flash[:error] = "There was an error adding the user."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_path, :notice => "User has been updated."
    else
      flash[:error] = "There was an error updating the user."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:notice] = "The user has been deleted."
    else
      flash[:error] = "There was an error deleting the user."
    end

    redirect_to admin_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :password, :is_admin, :distance_units)
  end
end
