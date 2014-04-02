Votatoes::Application.routes.draw do

  root 'pages#root'

  get "pages/home"
  get 'pages/about', :as => 'about'

  scope 'votatos', :controller => 'votatos' do
    get 'find', :as => 'find_votato'
    get 'search', :as => 'search_votato'
    get ':obj_id/tvdb' => 'votatos#new_tvdb_votato', :as => 'new_tvdb_votato'
    get ':obj_id/tmdb' => 'votatos#new_tmdb_votato', :as => 'new_tmdb_votato'

    post 'query', :as => 'query_votato'
    post ':obj_id/tvdb' => 'votatos#create_tvdb_votato', :as => 'create_tvdb_votato'
    post ':obj_id/tmdb' => 'votatos#create_tmdb_votato', :as => 'create_tmdb_votato'
    post ':id/plant' => 'votatos#plan', :as => 'plant'
    post 'votatos/:id/pluck' => 'votatos#pluck', :as => 'pluck'

    delete ':id' => 'votatos#destroy', :as => 'destroy_votato'
  end

  resources :plantations
  # resources :votatos - Added by default

  # Devise
  devise_for :users
end
