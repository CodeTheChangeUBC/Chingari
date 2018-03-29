Rails.application.routes.draw do

  
  # Hidden routes for in-progress pages
  if Rails.env == 'development' || Rails.env == 'test' || Rails.env == 'stage'
    # Set root of application
    root 'static_pages#home'

    # Static pages roots
    get  '/home',     to: 'static_pages#home'
    get  '/about',    to: 'static_pages#about'
    get  '/resources',to: 'static_pages#resources'
  
    # Routes handled by Sessions
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    # Routes pertaining to users
    get '/signup', to: 'users#new' # Nicer route name than /users/new
    get '/preview_profile', to: 'users#preview_profile'
    resources :users
  else
    # Set root of application
    root 'static_pages#coming_soon'
  end

  # Catch-all route
  get '*path', to: 'static_pages#coming_soon'
end