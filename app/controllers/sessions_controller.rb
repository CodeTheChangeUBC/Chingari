class SessionsController < ApplicationController
  def new
  end

  # Create user from on-site form
  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user and user.authenticate(params[:session][:password])
  		log_in(user)
      # redirect_to "/users/#{user.id}"
      redirect_to '/'
  	else
  		flash.now[:danger] = "Invalid email/password confirmation!"
  		render 'new'
  	end
  end

  def destroy
  	log_out
  	redirect_to root_url
    flash.now[:info] = "Successfully signed out"
  end

  # Create user from third party API 
  def create_with_api
    @user = User.find_or_create_from_auth_hash(request.env["omniauth.auth"])
    if @user
      session[:user_id] = @user.id
      redirect_to @user
    else 
      flash.now[:danger] = "Whoops, something went wrong!"
      render 'new'
    end
  end

  
end
