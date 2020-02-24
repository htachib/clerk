Rails.application.routes.draw do

  root 'pages#home'
  get 'oauth2callback', to: 'pages#home'

  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_scope :user do
    get 'start', to: "registrations#start", as: 'start'
    get 'login', to: "sessions#new", as: 'login'
    get 'settings', to: "registrations#edit", as: 'settings'
    delete 'logout', to: "sessions#destroy", as: 'logout'
  end

  resources :dashboard, only: [:index]
  resources :admin, only: [:index]
end
