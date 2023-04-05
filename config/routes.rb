Rails.application.routes.draw do
  resources :reviews
  resources :skippers
  resources :users
  
  devise_for :users, :path_prefix => 'my'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'pages#index'
end
