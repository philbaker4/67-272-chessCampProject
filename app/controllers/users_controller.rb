class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  include AppHelpers::Cart

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      session[:user_id] = @user.id
      create_cart

      redirect_to(home_path)
    end

  end
  def show 

  end

  def update
    if @current_user.update_attributes(user_params)
      redirect_to(@current_user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def index
    @active_users = User.all.active.paginate(:page => params[:page]).per_page(12)
    @inactive_users = User.all.inactive.paginate(:page => params[:page]).per_page(12)
  end


  private
    def set_user
      @user = User.find(params[:id])
    end

  def user_params
    params.require(:user).permit(:username, :email, :phone, :role, :password, :password_confirmation)
  end



end
