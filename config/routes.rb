Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      invitations: "users/invitations"
    }

  scope module: "admin" do
    resources :users, only: [:index, :new, :create, :destroy]
  end

  resources :users, only: [:show, :edit, :update]

  resources :addresses
  resources :categories
  resources :orders
  resources :order_items
  resources :products
  resources :price_list_items, except: [:create, :destroy], path: "price-list"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "orders#new"
end
