Votatoes::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'pages#root'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get "pages/home"
  get 'votatos/find', :as => 'find_votato'
  get 'votatos/search', :as => 'search_votato'
  # post 'votatos/search', :as => 'search_votato'
  get 'votatos/new/:series_id' => 'votatos#new_votato', :as => 'new_votato'
  post 'votatos/create/:series_id' => 'votatos#create_votato', :as => 'create_votato'
  delete 'votatos/:id' => 'votatos#destroy', :as => 'destroy_votato'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  post 'votatos/:id/plant' => 'votatos#plant', :as => 'plant'
  post 'votatos/:id/pluck' => 'votatos#pluck', :as => 'pluck'

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :plantations
  # resources :votatos - Added by default

  # Devise
  devise_for :users

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
