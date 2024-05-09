class HomesController < ApplicationController
before_action :authenticate_user!

  def top
    @timeline = Post.all
    @posts = current_user.posts
    @post = Post.find(current_user.id)
  end
end
