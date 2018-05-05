class DashboardsController < ApplicationController

  def show 
    if logged_in? and current_user.role?(:admin) 
      # admin stuff 
    elsif logged_in? and current_user.role?(:instructor) 
      # instructor stuff
    elsif logged_in? and current_user.role?(:parent)

      @user = Family.find_by_user_id(current_user.id)
      @students = @user.students.alphabetical
      upc_camps = []
      @students.each do |s|
        s.camps.upcoming.chronological.each do |c|
          upc_camps << c
        end
      end


      @upcoming_camps = upc_camps.paginate(:page => params[:page], :per_page => 10)
    # parent stuff 
    else
      redirect_to home_path
    end
  end

  
end