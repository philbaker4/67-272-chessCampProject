class RegistrationsController < ApplicationController
    include AppHelpers::Cart

  def new
    @registration  = Registration.new
    reg_ids = get_array_of_ids_for_generating_registrations
    @camp          = Camp.find(reg_ids[0][0])
    @student       = Student.find(reg_ids[0][1])


  end
  
  def create
    reg_ids = get_array_of_ids_for_generating_registrations

    reg_ids.each do |ri|
      par = {camp_id: ri[0], student_id: ri[1], credit_card_number: registration_params["credit_card_number"], expiration_month: registration_params["expiration_month"].to_i, expiration_year: registration_params["expiration_year"].to_i}
    


      @registration = Registration.new(par)
      if @registration.save
        payment = @registration.pay
        flash[:notice] = "Successfully registered"
        remove_registration_from_cart(par[:camp_id],par[:student_id])
        puts 111111111111111111
        puts par[:camp_id]
        puts par[:student_id]
        puts
        puts
        puts session[:cart]
        puts
        #puts get_array_of_ids_for_generating_registrations.nil?
        puts
        puts
        puts

      else
        @camp = Camp.find(params[:registration][:camp_id])
        @student = Student.find(params[:registration][:student_id])
        render action: 'new', locals: { camp: @camp, student: @student }
      end
    end
  end
 
  def destroy

    camp_id = params[:id]
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

