Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:destroy]
  end

  scope module: :public do
    root to: "homes#top"
    devise_for :users
    devise_scope :user do
      post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
    end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    resources :users, only: [:edit, :update, :index, :show] do
      resource :relationships, only: [:create, :destroy]
        get "followings" => "relationships#followings", as: "followings"
        get "followers" => "relationships#followers", as: "followers"
      member do
        get :favorites
      end
    end

    resources :posts, only: [:new, :create, :edit, :update, :show, :index] do
    resources :comments,only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end

    resources :lists, only: [:update] do
      member do
        get :move_higher
        get :move_lower
      end
    end

    resources :notifications, only: [:index, :update]

    get "/search", to: "searches#search"
  end
end
