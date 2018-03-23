Rails.application.routes.draw do
	# Set root of application
  root 'static_pages#coming_soon'
  
  # Hidden routes for in-progress pages
  if Rails.env == 'development' || Rails.env == 'test'
    # Static pages roots
    get  '/home',     to: 'static_pages#index'
    get  '/index',    to: 'static_pages#index'
    get  '/about',    to: 'static_pages#about'
    get  '/resources',to: 'static_pages#resources'
    get '/policies',  to: 'static_pages#policies'
  
    # Routes handled by Sessions
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    # Routes pertaining to users
    get '/signup', to: 'users#new' # Nicer route name than /users/new
    get '/preview_profile', to: 'users#preview_profile'
    resources :users

    # Api routes
    get '/auth/:provider/callback', to: 'sessions#create_with_api'
    get '/auth/failure', to: redirect('/')

  end

  # Catch-all route
  get '*path', to: 'static_pages#coming_soon'
end