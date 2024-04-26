class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post_id
    comment.save
    redirect_to root_path
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to root_path
    # リダイレクト先は投稿の詳細ページにする
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
