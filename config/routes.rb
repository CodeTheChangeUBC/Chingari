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
    get '/community/*subpath',       to: 'static_pages#community'
    get '/community',       to: 'static_pages#community'

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
    get '/courses/new', to: 'courses#new'
    get '/courses/:course_id', to: 'courses#show'  # Should go last as it also catches most of the other routes
    put '/courses/:course_id', to: 'courses#update' # ^^^^
    delete '/courses/:course_id', to: 'courses#delete' # ^^^^
    get '/courses/:course_id/edit', to: 'courses#edit'  # ^^^^

    # Attachments API
    get '/courses/(:course_id)/attachments', to: 'courses#attachment_index'
    post '/courses/(:course_id)/attachments', to: 'courses#attachment_create'
    get '/courses/(:course_id)/attachments/documents/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Document' }
    get '/courses/(:course_id)/attachments/embeds/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Embed' }
    put '/courses/(:course_id)/attachments/(:attach_id)', to: 'courses#attachment_edit'
    delete "/courses/(:course_id)/attachments/documents/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Document' }
    delete "/courses/(:course_id)/attachments/embeds/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Embed' }

    get "/authorize/:user_id", to: "users#authorize"
    
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
    get '/community/*subpath',       to: 'static_pages#community'
    get '/community',       to: 'static_pages#community'

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
    get '/courses/new', to: 'courses#new'
    get '/courses/:course_id', to: 'courses#show'  # Should go last as it also catches most of the other routes
    put '/courses/:course_id', to: 'courses#update' # ^^^^
    delete '/courses/:course_id', to: 'courses#delete' # ^^^^
    get '/courses/:course_id/edit', to: 'courses#edit'  # ^^^^

    # Attachments API
    get '/courses/(:course_id)/attachments', to: 'courses#attachment_index'
    post '/courses/(:course_id)/attachments', to: 'courses#attachment_create'
    get '/courses/(:course_id)/attachments/documents/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Document' }
    get '/courses/(:course_id)/attachments/embeds/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Embed' }
    put '/courses/(:course_id)/attachments/(:attach_id)', to: 'courses#attachment_edit'
    delete "/courses/(:course_id)/attachments/documents/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Document' }
    delete "/courses/(:course_id)/attachments/embeds/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Embed' }

    get "/authorize/:user_id", to: "users#authorize"
  # Released routes
  elsif Rails.env == 'production'
    # Set root of application
    root 'static_pages#home'

    # Static pages routes
    get '/home',            to: 'static_pages#home'
    get '/about',           to: 'static_pages#about'
    get '/resources',       to: 'static_pages#resources'
    get '/stories',         to: 'static_pages#stories'
    get '/public_speaking', to: 'static_pages#public_speaking'
    get '/policies',        to: 'static_pages#policies'
    get '/community/*subpath',       to: 'static_pages#community'
    get '/community',       to: 'static_pages#community'

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
    get '/courses/new', to: 'courses#new'
    get '/courses/:course_id', to: 'courses#show'  # Should go last as it also catches most of the other routes
    put '/courses/:course_id', to: 'courses#update' # ^^^^
    delete '/courses/:course_id', to: 'courses#delete' # ^^^^
    get '/courses/:course_id/edit', to: 'courses#edit'  # ^^^^

    # Attachments API
    get '/courses/(:course_id)/attachments', to: 'courses#attachment_index'
    post '/courses/(:course_id)/attachments', to: 'courses#attachment_create'
    get '/courses/(:course_id)/attachments/documents/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Document' }
    get '/courses/(:course_id)/attachments/embeds/(:attach_id)', to: 'courses#attachment_get', defaults: { type: 'Embed' }
    put '/courses/(:course_id)/attachments/(:attach_id)', to: 'courses#attachment_edit'
    delete "/courses/(:course_id)/attachments/documents/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Document' }
    delete "/courses/(:course_id)/attachments/embeds/(:attach_id)", to: 'courses#attachment_delete', defaults: { type: 'Embed' }

    get "/authorize/:user_id", to: "users#authorize"
  end

  # Catch-all route
  get '*path', to: 'static_pages#coming_soon'
end
