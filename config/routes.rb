Rails.application.routes.draw do
	# Set root of application
  root 'static_pages#coming_soon'
  
    # Static pages roots
  get  '/home',     to: 'static_pages#index'
  get  '/index',    to: 'static_pages#index'
  get  '/about',    to: 'static_pages#about'
  get  '/resources',to: 'static_pages#resources'

	# Set root of application
  root 'static_pages#home'

    # Static pages roots
  get  '/home',     to: 'static_pages#index'
  get  '/about',    to: 'static_pages#about'
  get  '/resources',to: 'static_pages#resources'

	# Routes handled by Sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # Routes pertaining to users
  get '/signup', to: 'users#new' # Nicer route name than /users/new
	resources :users
end
