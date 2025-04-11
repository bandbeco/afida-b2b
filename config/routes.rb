Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      invitations: "users/invitations"
    }

  # Defines the root path route ("/")
  root "orders#new"

  resources :addresses do
    member do
      patch :set_default_shipping
      patch :set_default_billing
    end
  end

  # Admin Namespace
  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :price_list_items, only: [:index], path: "price-list"
      resources :addresses # Nested address routes for admin
    end
    resources :price_list_items, only: [:edit, :update], path: "price-list"
  end

  # Non-admin routes
  resources :price_list_items, only: [:show], path: "price-list"
  resources :users, only: [:show, :edit, :update]
  resources :products
  resources :categories, except: [:destroy]

  resources :orders do
    get "summary", on: :member
  end

  resources :shopping_cart_items do
    member do
      patch :add_to_cart
      patch :remove_from_cart
    end
  end

  get 'postcode_lookup', to: 'postcode_lookups#new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
