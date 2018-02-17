module SessionsHelper

	# Logs in user
	def log_in(user)
		sessions[:user_id] = user.id
	end

	# Returns current logged in user
	def current_user
		@current_user ||= User.find_by(id: sessions[:user_id])
	end

	# Returns true iff current user is logged in
	def logged_in? 
		!current_user.nil?
	end
end
