Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
  resources :users,only: [:edit, :update, :index, :show]
  resources :posts,only: [:new, :create, :edit, :update, :show, :index] do
    resources :comments,only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
  resources :lists,only: [:update]
get "/search", to: "searches#search"
end
