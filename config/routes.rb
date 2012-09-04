Blog::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  resources :tutorials do
  	resources :steps
  end

  resources :tags

  get "admin/index"
  get "admin/show"
  match "/contact" => "articles#contact", :as => :contact
  match "/about" => "articles#about", :as => :about
  #match "/archive" => "articles#archive", :as => :archive
  #match "/:year(/:month(/:day))" => "articles#archive", :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ }
  match "/:year(/:month(/:day))" => "articles#archive", :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ }
    
  resources :roles

  devise_for :users,  :controllers => { :registrations => "users/registrations" }
  
  resources :articles do
    resources :comments
  end
  
  match "/sitemap" => "sitemap#index", :as => :sitemap, :defaults => {:format => :xml}
  match "/allcomments" => "comments#getall", :as => :getall, :defaults => {:format => :html}

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'articles#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
