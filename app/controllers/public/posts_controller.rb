class Public::PostsController < ApplicationController

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
    @timeline = Post.page(params[:page]).per(8)
    @posts = current_user.posts
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to posts_path
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end


  private


  def post_params
    params.require(:post).permit(:title, lists_attributes: [:id, :content, :_destroy])

  end

end
