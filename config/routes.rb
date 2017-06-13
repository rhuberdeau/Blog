Blog::Application.routes.draw do
  resources :contacts
  resources :articles
  resources :tags
  # See how all your routes lay out with "rake routes"

  devise_for :users, controllers: { registrations: "registrations"}
  root :to => 'articles#index'

  get '/about',   to: 'static_pages#about'
  # get '/contact', to: 'static_pages#contact'

  get "admin", to: 'admin#index'
  get "/sitemap" => "sitemap#index", :as => :sitemap, :defaults => {:format => :xml}

  namespace :articles do
    resources :publish, only: [:update]
  end
end
