Rails.application.routes.draw do
  resources :friendships
  resources :reviews
  resources :skippers
  resources :users

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations: 'users/confirmations'
  }, path_prefix: 'devise'

  root to: 'pages#index'
  get 'about' => 'pages#about'
  get 'contact' => 'pages#contact'
  post 'contact' => 'pages#send_contact'
  get 'privacy_policy' => 'pages#privacy_policy'
  get 'terms_of_service' => 'pages#terms_of_service'
  get 'invite' => 'pages#invite'
  post 'invite' => 'pages#send_invite'
  
  get 'users/friends' => 'users#index_friends'
end
