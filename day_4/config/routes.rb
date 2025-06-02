Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Authenticated users are redirected to the articles index page
  authenticated :user do
    root 'articles#index', as: :authenticated_root
  end

  # Unauthenticated users are redirected to the Devise sign-in page
  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Articles routes
  resources :articles do
    member do
      post :report
    end
  end
endw