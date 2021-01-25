Rails.application.routes.draw do
  resources :racks
  resources :box_types
  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
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
    get :sorter, :on => :collection
    patch :update_shelf_rack, :on=>:member
  end
  resources :shelves
  resources :containers do
    get :map_container, :on => :collection
  end
  resources :positions
  resources :shelf_racks do
    get :map_shelf_rack, :on => :collection
  end
  resources :users
  
  #Root
  root 'boxes#index'
end