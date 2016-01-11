Blog::Application.routes.draw do
  # See how all your routes lay out with "rake routes"
  
  devise_for :users
  root :to => 'articles#index'

  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get "admin", to: 'admin#index'
  get "/sitemap" => "sitemap#index", :as => :sitemap, :defaults => {:format => :xml}

  resources :tags
  resources :tutorials do
  	resources :steps
  end
  resources :articles do
    resources :comments
  end
end
