# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Home
  get 'home/index'
  get 'home/login'
  get 'home/signup'

  # User
  resources :users

  # Confirmations
  resources :confirmations, only: %i[new create show], param: :token

  # Defines the root path route ("/")
  root to: redirect('/home/index')
end
