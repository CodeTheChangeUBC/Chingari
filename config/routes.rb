Rails.application.routes.draw do

	# Set root of application
  root 'static_pages#home'

	# Routes handled by Sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # Routes pertaining to users
  get '/signup', to: 'users#new' # Nicer route name than /users/new
	resources :users
end
