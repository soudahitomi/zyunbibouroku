class Public::CommentsController < ApplicationController
  # before_action :is_matching_login_user, only: [:destroy]
  
  def create
    @post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = @post.id
    if comment.save
      redirect_to post_path(@post.id)
    else
      @error_comment = comment
      @post = Post.find(params[:post_id])
      @comment = Comment.new
      render "public/posts/show"
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to post_path(params[:post_id])
    end
  end
end
