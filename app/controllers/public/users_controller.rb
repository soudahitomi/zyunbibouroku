class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]

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
    @post = Post.find(params[:id])
  end

  def favorites
    @user = User.find(params[:id])
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
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール画面に遷移できません。"
    end
  end
end
