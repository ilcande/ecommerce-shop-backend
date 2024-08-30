Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users, controllers: { sessions: 'users/sessions' }

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root 'pages#home'
  get 'pages/home'

  # Admin namespace for admin-related routes
  namespace :admin do
    resources :dashboard, only: [:index]

    resources :products, only: [:create, :update, :destroy] do
      resources :product_configurations, only: [:index, :create]
    end
    resources :parts do
      resources :options, only: [:index, :create, :show, :update, :destroy]
      resources :constraints, only: [:index, :create]
    end
    resources :options, only: [:index, :show]
    resources :constraints, only: [:index, :show, :create, :update, :destroy]
    resources :stock_levels, only: [:index, :show, :update]
    # Admin-specific cart management if needed
    resources :cart_items, only: [:index, :create, :update, :destroy]
  end

  # Public routes for customers
  resources :products, only: [:index, :show] # Restrict public product actions to read-only
  resources :cart_items, only: [:index, :create, :update, :destroy]
  post '/checkout', to: 'orders#checkout'

  # Custom route for fetching constraints based on part IDs
  get 'constraints', to: 'constraints#index'
end
