class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  authorize_resource


  def index
    @active_students = Student.all.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_students = Student.all.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @student_student = @student.student
    @past_camps_for_student = @student.camps.past.chronological.paginate(page: params[:page]).per_page(5)
    @upcoming_camps_for_student = @student.camps.upcoming.chronological.paginate(page: params[:page]).per_page(5)

  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.first_name @student.last_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    @student.update(student_params)
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.first_name @student.last_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "#{@student.first_name @student.last_name} was removed from the system."
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :family_id, :date_of_birth, :rating)
    end
end