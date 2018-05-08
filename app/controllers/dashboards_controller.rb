class DashboardsController < ApplicationController

  def show 
    if logged_in? and current_user.role?(:admin)

      next_mon = 
      
      @camps_this_week = Camp.upcoming.where('start_date < ? ', date_of_next("Monday")).chronological.paginate(:page => params[:page], :per_page => 5)

      # @unpaid_registrations = []
      # Camp.upcoming.chronological.each do |c|
      #   if !c.registrations.empty?
      #     Registration.for_camp(c.id).alphabetical do |r|
      #       @unpaid_registrations << r
      #     end
      #   end
      # end

      # @unpaid_registrations.paginate(:page => params[:page], :per_page => 10)


      @unpaid_registrations = Registration.joins(:camp).where(' ? <= start_date and payment is NULL', Date.today).paginate(:page => params[:page]).per_page(7)




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

  def date_of_next(day)
        date  = Date.parse(day)
        delta = date > Date.today ? 0 : 7
        date + delta
      end


  
end 