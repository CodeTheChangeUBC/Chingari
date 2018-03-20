Rails.application.routes.draw do
	# Set root of application
  root 'static_pages#coming_soon'

    # Static pages roots
  get  '/home',     to: 'static_pages#index'
  get  '/index',    to: 'static_pages#index'
  get  '/about',    to: 'static_pages#about'
  get  '/resources',to: 'static_pages#resources'

	# Set root of application
  root 'static_pages#coming_soon'

    # Static pages roots
  get  '/home',     to: 'static_pages#index'
  get  '/index',    to: 'static_pages#index'
  get  '/about',    to: 'static_pages#about'
  get  '/resources',to: 'static_pages#resources'

	# Routes handled by Sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

<<<<<<< HEAD
  # Courses Routes
  get '/test_courses', to: 'courses#view'
=======
    # Routes pertaining to users
    get '/signup', to: 'users#new' # Nicer route name than /users/new
    get '/preview_profile', to: 'users#preview_profile'
    resources :users
  end
>>>>>>> 3d6a30f5c2a36cb4e91fa516dae431dd93336f64

  # Routes pertaining to users
  get '/signup', to: 'users#new' # Nicer route name than /users/new
	resources :users
end
