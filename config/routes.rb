Rails.application.routes.draw do
  resources :friendships
  resources :reviews
  resources :skippers
  resources :users

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, path_prefix: 'devise'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: 'pages#index'
  get 'pages/about' => 'pages#about', as: 'about'
  get 'pages/contact' => 'pages#contact', as: 'contact'
  get 'pages/privacy_policy' => 'pages#privacy_policy', as: 'privacy_policy'
  get 'pages/terms_of_service' => 'pages#terms_of_service', as: 'terms_of_service'
end
