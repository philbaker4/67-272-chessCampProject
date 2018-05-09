class CampsController < ApplicationController
  before_action :set_camp, only: [:show, :edit, :update, :destroy, :instructors, :registrations]
  authorize_resource

  include AppHelpers::Cart

  def index
    @upcoming_camps = Camp.all.upcoming.chronological.paginate(:page => params[:page]).per_page(10)
    @past_camps = Camp.all.past.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @instructors = @camp.instructors.alphabetical
    @students = @camp.students.alphabetical.paginate(:page => params[:page]).per_page(10)

    same_time_slot_camp = Camp.where('start_date = ? and time_slot = ?', @camp.start_date, @camp.time_slot).alphabetical.map{|c| c.students.to_a}.to_a.flatten!
    if logged_in? and current_user.role? :admin
      @students_for_camp = Student.active.at_or_above_rating(@camp.curriculum.min_rating).below_rating(@camp.curriculum.max_rating).alphabetical.to_a - same_time_slot_camp
    elsif logged_in? and current_user.role? :parent
      @students_for_camp = Family.find_by_user_id(current_user.id).students.active.at_or_above_rating(@camp.curriculum.min_rating).below_rating(@camp.curriculum.max_rating).alphabetical.to_a - same_time_slot_camp
    end
    same_time_slot_instructor = Camp.where('start_date = ? and time_slot = ?', @camp.start_date, @camp.time_slot).alphabetical.map{|c| c.instructors.to_a}.to_a.flatten!

    @potential_instructors = Instructor.active.alphabetical.to_a - @instructors.to_a - same_time_slot_instructor

  end

  def edit 
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @camp.update(camp_params) 
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} was removed from the system."
  end

  def instructors
    @instructors = Instructor.for_camp(@camp).alphabetical
  end


  def add_to_cart
    add_registration_to_cart(params[:registration][:camp_id], params[:registration][:student_id])
    flash[:notice] = "Added 1 registration to the cart."
    redirect_to camp_path(Camp.find(params[:registration][:camp_id]))
  end

  def remove_one_from_cart
    remove_one_registration_from_cart(params[:registration][:camp_id], params[:registration][:student_id])
    flash[:notice] = "Removed registration from the cart."
    redirect_to view_cart_path
  end

  def delete_from_cart
    remove_registration_from_cart(params[:id], params[:student_id])
    flash[:notice] = "Removed registration from the cart."
    redirect_to view_cart_path
  end


  private
    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end