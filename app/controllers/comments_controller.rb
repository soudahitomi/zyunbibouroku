class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
      redirect_to post_path(post.id)
    else
      @post = Post.find(params[:id])
      @comment = Comment.new
      render "posts/show"
    end
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
