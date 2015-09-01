WhaleProject::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}

  # authenticated :user do
  #   root to: "fundraisers#index", as: :authenticated_root
  # end

  # unauthenticated do
  #   root to: "home#index"
  # end

  
  # get "casinos/index"
  # get "casinos/new"
  # get "casinos/show"
  # get "casinos/edit"
  # get "casinos/delete"
  # get "offers/index"
  # get "offers/show"
  # get "offers/new"
  # get "offers/edit"
  
  resources :bids do
    collection do
      get :current
      get :history
      get :browse_markets
      get :browse_casinos
      get :casino_bids
    end
    member do
      get :delete
      get :cancel
      get :decline

    end
  end

  get "show_perks/:player_category" => "bids#show_perks"
  
  resources :casinos do
    member do
      get :delete
    end
  end
  
  resources :offers do
    collection do
      get :history
    end

    member do
      get :delete
      get :accept
      get :decline
      get :respond
      get :confirm
    end
  end
  
  match ':controller(/:action(/:id))', via: [:get, :post, :delete]
  
  # get "bids/index"
  # get "bids/new"
  # get "bids/show"
  # get "bids/edit"
  # get "bids/delete"
  root "pages#home"
  
  get "about" => "pages#about"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
