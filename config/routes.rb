Rails.application.routes.draw do

  # Hidden routes for in-progress pages
  if Rails.env == 'development' || Rails.env == 'test' || Rails.env == 'stage'
    # Set root of application
    root 'static_pages#home'

    # Static pages roots
    get  '/home',     to: 'static_pages#home'
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

    # Routes pertaining to courses
    get '/courses', to: 'courses#index'
    post '/courses', to: 'courses#create'
    get '/courses/review', to: 'courses#review'
    get '/courses/drafts', to: 'courses#drafts'
    get '/courses/published', to: 'courses#published'
    get '/courses/new', to: 'courses#new'
    get '/courses/:course_id', to: 'courses#getcourse'  # Should go last as it also catches most of the other routes
    put '/courses/:course_id', to: 'courses#update' # ^^^^
    delete '/courses/:course_id', to: 'courses#delete' # ^^^^
    get '/courses/:course_id/edit', to: 'courses#edit'  # ^^^^
    resources :courses

  else
    # Set root of application
    root 'static_pages#coming_soon'
    
    # Api routes
    get '/auth/:provider/callback', to: 'sessions#create_with_api'
    get '/auth/failure', to: redirect('/')
  end

  # Catch-all route
  get '*path', to: 'static_pages#coming_soon'
end