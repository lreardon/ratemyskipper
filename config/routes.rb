Rails.application.routes.draw do
  resources :friendships
  resources :reviews
  resources :skippers
  resources :users

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, path_prefix: 'devise'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'pages#index'
end
