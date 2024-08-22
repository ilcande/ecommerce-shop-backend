Rails.application.routes.draw do
  get 'pages/home'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root 'pages#home'

  # Product routes
  resources :products do
    resources :product_configurations, only: [:index, :create]
  end

  # Part routes
  resources :parts do
    resources :options, only: [:index, :create]
    resources :constraints, only: [:index, :create]
  end

  # Additional routes
  resources :options, only: [:index, :show]
  resources :constraints, only: [:index, :show, :create, :update, :destroy]
  resources :stock_levels, only: [:index, :show, :update]

  # Cart routes
  resources :cart_items, only: [:index, :create, :update, :destroy]

  # Admin routes
  namespace :admin do
    resources :products, only: [:create, :update, :destroy]
    resources :parts, only: [:create, :update, :destroy]
    resources :options, only: [:create, :update, :destroy]
  end

  # Authentication routes
  namespace :auth do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

  # User routes
  resources :users, only: [:create, :show]
end
