class UsersController < ApplicationController
  before_action :correct_member?, only: [:edit, :update, :destroy]

  def authorize
    user = User.find(params[:user_id]) || current_user
    if user && user.role == Role.admin || user.role == Role.moderator
      render status: 200, json: { result: 'authorized' }
    else
      render status: 401, json: { result: 'unauthorized' }
    end
  end

  def index
    # temporarily redirect
    return redirect_to '/'

  	@users = User.all.order(:created_at)
  end

  def preview_profile
    # temporarily redirect
    return redirect_to '/'
  end

  def show 
    # temporarily redirect
    return redirect_to '/'
  	@user = User.find(params[:id])
  end

  def new 
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in(@user)
  		flash[:success] = "Account created!"
      # redirect_to @user
      redirect_to "/"
  	else 
  		render 'new'
  	end
  end

  def edit 
    # temporarily redirect
    return redirect_to '/'
    @user = User.find(params[:id])
  end

  def update 
    # temporarily redirect
    return redirect_to '/'
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    # temporarily redirect
    return redirect_to '/'
    User.find(params[:id]).destroy
    flash[:success] = "Profile Updated Successfully."
    redirect_to root_url
  end



  private 
  	def user_params
  		params.require(:user).permit(:username, :name, :email, :password, 
  									:password_confirmation)
  	end

end
