Rails.application.routes.draw do

	# Routes handled by Sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # Routes regarding users
  get '/signup', to: 'users#new' # Nicer route name than /users/new
	resources :users
end
