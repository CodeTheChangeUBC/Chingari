Rails.application.routes.draw do

  # Routes in development / testing
  if Rails.env == 'development' || Rails.env == 'test'
    # Set root of application
    root 'static_pages#home'

    # Static pages routes
    get '/home',            to: 'static_pages#home'
    get '/about',           to: 'static_pages#about'
    get '/resources',       to: 'static_pages#resources'
    get '/stories',         to: 'static_pages#stories'
    get '/public_speaking', to: 'static_pages#public_speaking'
    get '/policies',        to: 'static_pages#policies'
  
    # Session routes
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    # Users API
    get '/signup', to: 'users#new' # Nicer route name than /users/new
    resources :users

    # Courses API
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

  # Staged routes
  elsif Rails.env == 'stage'
    # Set root of application
    root 'static_pages#home'

    # Static pages routes
    get '/home',            to: 'static_pages#home'
    get '/about',           to: 'static_pages#about'
    get '/resources',       to: 'static_pages#resources'
    get '/stories',         to: 'static_pages#stories'
    get '/public_speaking', to: 'static_pages#public_speaking'
    get '/policies',        to: 'static_pages#policies'
  
    # Session routes
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    # Users API
    get '/signup', to: 'users#new' # Nicer route name than /users/new
    resources :users

    # Courses API
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

  # Released routes
  elsif Rails.env == 'production'
    # Set root of application
    root 'static_pages#home'

    # Static pages routes
    get '/home',            to: 'static_pages#home'
    get '/about',           to: 'static_pages#about'
    # get '/resources',       to: 'static_pages#resources'
    get '/stories',         to: 'static_pages#stories'
    get '/public_speaking', to: 'static_pages#public_speaking'

    # Session routes
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

    # OAuth API routes
    get '/auth/:provider/callback', to: 'sessions#create_with_api'
    get '/auth/failure', to: redirect('/')
  end

  # Catch-all route
  get '*path', to: 'static_pages#coming_soon'
end