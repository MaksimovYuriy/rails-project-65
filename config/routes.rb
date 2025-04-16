# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'web/bulletins#index'

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#logout', as: :auth_logout
    get 'auth/failure', to: 'auth#failure'

    resources :bulletins, except: %i[destroy] do
      member do
        patch :to_moderate
        patch :archive
      end
    end

    resources :profile, only: [:index]

    namespace :admin do
      root to: 'bulletins#on_moderate'

      resources :categories, except: %i[show]
      resources :bulletins, only: %i[index] do
        member do
          patch :to_moderate
          patch :reject
          patch :publish
          patch :archive
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
