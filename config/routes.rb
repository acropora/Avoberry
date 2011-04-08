Avoberry::Application.routes.draw do

  resources :users do
    post :reset, :on => :collection
    post :comment, :on => :member
    post :comment_reply, :on => :member
  end
  
  ###posts
  resources :posts
  ###end posts
  
  ### friendships
  resources :friendships do
    post :create_request, :on => :collection
  end
  ###end friendships
  
  resources :sessions, :only => [:new, :create, :destroy]
  
  ### Conversations
  resources :conversations do
    post :reply, :on => :member
    get :inbox, :on => :collection
    get :sent, :on => :collection
  end
  ### end conversations

  get '/contact' => 'pages#contact'
  get '/about' => 'pages#about'
  get '/help' => 'pages#help'
  get 'signup' => 'users#new'
  get '/signin' => 'sessions#new'
  get '/recover' => 'pages#recover'
  
  delete '/signout' => 'sessions#destroy'
  
  root :to => 'pages#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
