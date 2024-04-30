Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  resources :users,only: [:edit, :update, :index]
  resources :posts,only: [:new, :create, :edit, :update, :show, :index] do
    resources :comments,only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
get "/seach", to: "seaches#seach"
end
