Rails.application.routes.draw do
  root to: 'web/bulletins#index'

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#logout', as: :auth_logout

    resources :bulletins, only: %i[index show new create] do
      collection do
        get :search
      end
      member do
        patch :to_moderate
        patch :archive
      end        
    end

    resource :profile, only: [:show], controller: 'bulletins', action: 'profile'
  

    scope module: :admin do
      resources :categories, except: %i[show]
      resources :bulletins, only: %i[index], path: '/admin/bulletins', as: 'admin_bulletins' do
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
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
