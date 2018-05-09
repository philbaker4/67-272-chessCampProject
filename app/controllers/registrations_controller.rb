class RegistrationsController < ApplicationController
    include AppHelpers::Cart
    authorize_resource
  def new
    @registration  = Registration.new
    @cart_reg = get_array_of_ids_for_generating_registrations
    @camp          = Camp.find(@cart_reg[0][0])
    @student       = Student.find(@cart_reg[0][1])
    @price = calculate_total_cart_registration_cost

 


  end
  
  def create
    @reg_ids = get_array_of_ids_for_generating_registrations

    @reg_ids.each do |ri|
      par = {camp_id: ri[0], student_id: ri[1], credit_card_number: registration_params["credit_card_number"], expiration_month: registration_params["expiration_month"].to_i, expiration_year: registration_params["expiration_year"].to_i}
    


      @registration = Registration.new(par)
      if @registration.save
        payment = @registration.pay

        flash[:notice] = "Successfully registered"

      else

        @camp = Camp.find(params[:registration][:camp_id])
        @student = Student.find(params[:registration][:student_id])
        if Registration.where("camp_id = ? and student_id = ?", @camp.id, @student.id).empty?
          render action: 'new', locals: { camp: @camp, student: @student }
        end
      end
    end

    @reg_ids.each do |ri|
      remove_registration_from_cart(ri[0],ri[1])
    end



  end
 
  def destroy

    camp_id = params[:camp_id]
    student_id = params[:student_id]
    @registration = Registration.where(camp_id: camp_id, student_id: student_id).first
    unless @registration.nil?
      @registration.destroy
      flash[:notice] = "Successfully removed this registration"
    else
      flash[:notice] = "Unable to remove registration"
    end

  end

  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id, :credit_card_number, :expiration_year, :expiration_month)
    end

end  

