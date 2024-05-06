# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :appointments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # mount Sidekiq::Web
  mount Sidekiq::Web => '/sidekiq'

  # Home
  get 'home/index'
  get 'home/login'
  get 'home/signup'

  # User
  resources :users

  # Confirmations
  resources :confirmations, only: %i[new create show], param: :token

  # Authentication
  resource :auth, controller: :auth, only: %i[new create destroy]

  # Profile
  resource :profile, controller: :profile, only: %i[show edit update]

  # Doctors
  resources :doctors, only: %i[index show]

  # Defines the root path route ("/")
  root to: redirect('/home/index')
end
