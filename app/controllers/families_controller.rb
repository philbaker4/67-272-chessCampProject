class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  authorize_resource


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
    if @family.save
      redirect_to family_path(@family), notice: "The #{@family.family_name} family was added to the system."
    else
      render action: 'new'
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
      params.require(:family).permit(:family_name, :parent_first_name, :user_id)
    end
end