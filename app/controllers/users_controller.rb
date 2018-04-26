class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = current_user()
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      session[:user_id] = @user.id
      redirect_to(home_path)

  end

  def update
    if @current_user.update_attributes(user_params)
      redirect_to(@current_user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
  end


  private

  def user_params
      params.require(:user).permit(:username, :email, :phone, :role, :password, :password_confirmation)
    end
end
