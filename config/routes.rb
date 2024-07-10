Rails.application.routes.draw do
  resources :categories
  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      invitations: "users/invitations"
    }

  scope module: "admin" do
    resources :users
  end

  resources :addresses
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
