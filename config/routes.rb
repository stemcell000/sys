Rails.application.routes.draw do
  resources :box_types
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :vials do
    patch :update_box, :on => :member
    get :sorter, :on => :collection
    get :sort_tube, :on => :collection
    get :map_tube, :on => :collection
  end
  resources :boxes do
    get :fetch_vials, :on => :member
    get :fetch_position
  end
  resources :box_types
  resources :shelves
  resources :containers
  resources :positions
  resources :users
  
  #Root
  root 'boxes#index' 
end
