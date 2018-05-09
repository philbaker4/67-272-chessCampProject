class SessionsController < ApplicationController
    include AppHelpers::Cart

    def new
    end

    def create
      user = User.find_by_email(params[:email])

      if user && User.authenticate(params[:email], params[:password])
        session[:user_id] = user.id
        if user.role?(:admin) || user.role?(:parent)
          create_cart
        end
        redirect_to dashboard_path, notice: "Logged in!"
      else
        flash.now.alert = "Email or password is invalid"
        render "new"
      end
    end

    def destroy
      session[:user_id] = nil
      destroy_cart
      redirect_to home_path, notice: "Logged out!"
    end
  end
