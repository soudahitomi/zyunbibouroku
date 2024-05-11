class UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]

  def update
    @user = User.find(params[:id])
    @user.update
    redirect_to posts_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private


  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール画面に遷移できません。"
    end
  end
end
