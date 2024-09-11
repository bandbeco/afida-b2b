Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      invitations: "users/invitations"
    }

  scope module: "admin" do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :price_list_items, only: [:index], path: "price-list"
    end
    resources :price_list_items, only: [:edit, :update], path: "price-list"
  end

  resources :price_list_items, only: [:show], path: "price-list"
  resources :users, only: [:show, :edit, :update]

  resources :addresses
  resources :categories
  resources :orders do
    get "summary", on: :member
  end
  resources :order_items
  resources :products

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "orders#new"
end
