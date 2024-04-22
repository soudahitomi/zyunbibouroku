class PostController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to root_path
  end

  def edit
  end

  def update

  end


  private


  def post_params
    params.require(:post).permit(:title, :body)

  end


end
