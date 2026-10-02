Rails.application.routes.draw do
  resource :session, only: %i[ new create destroy ]
  resources :articles do
    # The editor's live preview: renders unsaved form values (author only).
    post :preview, on: :collection
  end
  resources :tags, only: :show
  put "articles/:id/publish", to: "articles/publish#update", as: :articles_publish

  root to: "articles#index"
  get "/about",   to: "static_pages#about"
  get "admin", to: "admin#index"
  get "/sitemap" => "sitemap#index", :as => :sitemap, :defaults => { format: :xml }
  get "feed" => "articles#feed", as: :feed, defaults: { format: :atom }

  # Load balancer / container health check: 200 if the app boots.
  get "up" => "rails/health#show", as: :rails_health_check
end
