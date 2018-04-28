class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include PaginationHelper
  include SearchHelper

  private 
  	# Returns true iff current member is the user associated 
  	# with the current page
  	def correct_member?
  		@user = User.find(params[:id])
  		if @user != current_user
  			redirect_to root_url 
  			flash[:danger] = "You don't permission to access this page"
  		end
  	end

end
