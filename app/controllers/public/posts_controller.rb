class Public::PostsController < ApplicationController
  before_action :is_matching_login_user_post, only: [:edit, :update]

  def new
    @post = Post.new
    @post.lists.build
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render action: :new
    end
  end

  def index
    @timeline = Post.all.order(created_at: :desc).page(params[:page]).per(8)
    @posts = current_user.posts.order(created_at: :desc)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end


  private


  def post_params
    params.require(:post).permit(:title, lists_attributes: [:id, :content, :_destroy])
  end

  def is_matching_login_user_post
    post = Post.find(params[:id])
    unless post.user.id == current_user.id
      redirect_to posts_path
    end
  end

end
