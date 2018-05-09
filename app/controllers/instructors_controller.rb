class InstructorsController < ApplicationController
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @active_instructors = Instructor.all.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_instructors = Instructor.all.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)

  end

  def show
    @past_camps = @instructor.camps.past.chronological.paginate(page: params[:page]).per_page(5)
    @upcoming_camps = @instructor.camps.upcoming.chronological.paginate(page: params[:page]).per_page(5)
  end

  def edit
  end

  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)
    @user = User.new
    @user.role = "instructor"
    @user.username = params[:instructor]["username"]
    @user.password = params[:instructor]["password"]
    @user.password_confirmation = params[:instructor]["password_confirmation"]
    @user.phone = params[:instructor]["phone"]
    @user.email = params[:instructor]["email"]
    if @user.valid?
      @instructor.user_id = User.where('role = ?', "admin").last.id 

      if @instructor.valid?
        @user.save
        @instructor.user_id = @user.id

        @instructor.save
        redirect_to instructor_path(@instructor)
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
    if @instructor.update(instructor_params)
      redirect_to instructor_path(@instructor), notice: "#{@instructor.first_name} #{@instructor.last_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.first_name} #{@instructor.last_name} was deleted from the system."
  end

  private
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :bio, :user_id,  :active, :username, :email, :phone, :password, :password_confirmation,)
    end
end