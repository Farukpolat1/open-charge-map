Rails.application.routes.draw do
  resource :session
  resource :registration, only: [ :new, :create ]
  resources :passwords, param: :token
  resource :profile, only: [ :show, :edit, :update ]
  resources :favorites, only: [ :create, :destroy ]
  resources :status_reports, only: [ :create ]
  resources :station_ratings, only: [ :create, :destroy ]

  get "/map", to: "stations#map"
  root "pages#home"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  post "/contact", to: "pages#contact"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/kvkk", to: "pages#kvkk"
  get "/cookies", to: "pages#cookie_policy", as: "cookies"
  get "/search", to: "stations#search"
  resources :stations

  get "up" => "rails/health#show", as: :rails_health_check

  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
