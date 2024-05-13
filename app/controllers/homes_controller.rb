class HomesController < ApplicationController

  def top
    @timeline = Post.all
    @posts = current_user.posts
    @post = Post.find(current_user.id)
  end
end
