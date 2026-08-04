Rails.application.routes.draw do
  # Le .com renvoie vers le .fr
  constraints(host: /\A(?:www\.)?mots-denfants\.com\z/) do
    match "(*path)", via: :all,
          to: redirect(status: 301) { |_params, request|
            "https://mots-denfants.fr#{request.fullpath}"
          }
  end

  devise_for :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"
  resources :children do
    resources :words, only: [ :new, :create, :edit, :update, :destroy ]
  end
  get "privacy_policy", to: "pages#privacy_policy"
  get "general_terms", to: "pages#general_terms"
  get "account_deletion", to: "pages#account_deletion"
end
