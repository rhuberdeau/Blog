Rails.application.routes.draw do
  resource :session, only: %i[ new create destroy ]
  resources :articles
  resources :tags, only: :show
  put "articles/:id/publish", to: "articles/publish#update", as: :articles_publish

  root to: "articles#index"
  get "/about",   to: "static_pages#about"
  get "admin", to: "admin#index"
  get "/sitemap" => "sitemap#index", :as => :sitemap, :defaults => { format: :xml }

  # Load balancer / container health check: 200 if the app boots.
  get "up" => "rails/health#show", as: :rails_health_check
end
