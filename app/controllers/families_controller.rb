class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  authorize_resource
      include AppHelpers::Cart



  def index
    @active_families = Family.all.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_families = Family.all.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @active_students = @family.students.active.alphabetical.paginate(page: params[:page]).per_page(7)
    @inactive_students = @family.students.inactive.alphabetical.paginate(page: params[:page]).per_page(7)
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @user = User.new
    @user.role = "parent"
    @user.username = params[:family]["username"]
    @user.password = params[:family]["password"]
    @user.password_confirmation = params[:family]["password_confirmation"]
    @user.phone = params[:family]["phone"]
    @user.email = params[:family]["email"]
    if @user.valid?
      @family.user_id = User.where('role = ?', 'admin').last.id 

      if @family.valid?
        @user.save
        @family.user_id = @user.id
        @family.save
        if !logged_in?
          reset_session
          destroy_cart
          redirect_to new_fam_login_path({email: @user.email, password: @user.password}) and return 
        end
        redirect_to family_path(@family)
      else
        flash[:notice] = "Family info not valid"
        render 'new'
      end

    else
      flash[:notice] = "User info not valid"
      render 'new'
    end

      
    
  end




  def update
    @family.update(family_params)
    if @family.save
      redirect_to family_path(@family), notice: "The #{@family.family_name} family was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @family.destroy
    redirect_to families_url, notice: "The #{@family.family_name} family was removed from the system."
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :username, :email, :phone, :password, :password_confirmation, :active)
    end

end