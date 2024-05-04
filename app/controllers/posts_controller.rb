class PostsController < ApplicationController

  def new
    @post = Post.new
    @post.lists.build
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

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end


  private


  def post_params
    params.require(:post).permit(:title, :body, lists_attributes: [:id, :content, :position, :_destroy])

  end

end
