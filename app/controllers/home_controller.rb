class HomeController < ApplicationController
  def index
    if logged_in? and current_user.role?(:admin)
      # admin stuff 
    elsif logged_in? and current_user.role?(:instructor) 
  
    elsif logged_in? and current_user.role?(:parent)
    
    else
    end
    
  
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
end