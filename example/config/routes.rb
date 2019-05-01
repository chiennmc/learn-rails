Rails.application.routes.draw do
  get     "/new_password_reset", to: "password_resets#new"
  post    "/password_resets",    to: "password_resets#create"

  get     "/login",              to: "sessions#new"
  post    "/login",              to: "sessions#create"
  delete  "/logout",             to: "sessions#destroy"

  get     "/signup",             to: "users#new"
  post    "/signup",             to: "users#create"
  get     "/help",               to: "static_pages#help"
  get     "/about",              to: "static_pages#about"
  get     "/contact",            to: "static_pages#contact"
  # delete  "/delete_micropost",   to: "microposts#destroy"
  
  resources :users do
    member do
      get :following, :followers
    end
  end

  root 'static_pages#home'
  resources :users
  resources :account_activation,  only: [:edit]
  resources :password_resets,     only: [:edit, :update, :show, :destory]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  # For details on the DSL available within this file, 
  # see http://guides.rubyonrails.org/routing.html
end
