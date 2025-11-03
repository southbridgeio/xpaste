Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  scope "(:locale)" do
    get "/health", to: "application#healthcheck"
    get "/error", to: "application#error"
    get "/html_error", to: "application#html_error"

    resources :p, controller: :paste, only: %i[new create show] do
      collection do
        get :help
        get :policy, as: :privacy_policy
      end

      member do
        get "/raw", to: "paste#show", constraints: ->(req) { req.params["raw"] = true }
      end
    end

    get "/help", to: "paste#help"
    get "/policy", to: "paste#privacy_policy"
    root to: "paste#new"
  end

  post "/paste-file", to: "paste#create_from_file"
end
