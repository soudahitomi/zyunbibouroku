class Public::CommentsController < ApplicationController

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
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy
      redirect_to post_path(params[:post_id])
    else
      flash[:alert] = 'このコメントを削除する権限がありません。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
