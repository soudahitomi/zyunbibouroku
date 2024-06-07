class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  before_action :is_matching_login_user, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to posts_path
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(8)
  end

  def favorites
    @user = User.find(params[:id])
    @posts = current_user.posts.page(params[:page]).per(8)
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to posts_path, notice: "ゲストユーザーはプロフィール画面に遷移できません。"
    end
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to posts_path
    end
  end
end
