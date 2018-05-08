class HomeController < ApplicationController

  include AppHelpers::Cart

  def index

  end

  def about
  end

  def contact
  end

  def privacy
  end

  def view_cart
    if !logged_in? || current_user.nil? || current_user.role?(:instructor) 
      flash[:error] = "You are not authorized to take this action. Please log in as an appropriate user."
      redirect_to home_path
    end
    
    @cart_items = get_array_of_ids_for_generating_registrations
    
    @cart_reg = []
    @cart_items.each do |ci| 
      camp = Camp.find(ci[0])
      student = Student.find(ci[1])
      @cart_reg << {:camp => camp , :student => student}
    end

    @price = calculate_total_cart_registration_cost


  end
  
end  