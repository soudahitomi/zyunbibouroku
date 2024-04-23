class PostController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to root_path
    else
      render action: :new
    end
  end

  def edit
  end

  def update

  end


  private


  def post_params
    params.require(:post).permit(:title, :body, list_attributes: [:id, :list_id, :content, :position, :_destroy])

  end

end
