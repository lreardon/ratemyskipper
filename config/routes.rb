require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
	authenticate :user, -> (u) { u.admin? } do
		mount Sidekiq::Web => '/sidekiq'
	end

	resources :friendships
	resources :reviews
	resources :skippers
	resources :users

	devise_for :users, controllers: {
		registrations: 'users/registrations',
		sessions: 'users/sessions',
		omniauth_callbacks: 'users/omniauth_callbacks',
		confirmations: 'users/confirmations',
		passwords: 'users/passwords'
	}, path_prefix: 'devise'

	get 'service-worker.js' => 'service_worker#service_worker'
	get 'manifest.json' => 'service_worker#manifest'

	root to: 'pages#index'
	get 'about' => 'pages#about'
	get 'contact' => 'pages#contact'
	post 'contact' => 'pages#send_contact'
	get 'privacy_policy' => 'pages#privacy_policy'
	get 'terms_of_service' => 'pages#terms_of_service'
	get 'invite' => 'pages#invite'
	post 'invite' => 'pages#send_invite'
	get 'offline' => 'pages#offline'

	get 'users/friends' => 'users#index_friends'
	post 'users/save_skipper/:skipper_id' => 'users#save_skipper', as: 'save_skipper'
	post 'users/unsave_skipper/:skipper_id' => 'users#unsave_skipper', as: 'unsave_skipper'
end
