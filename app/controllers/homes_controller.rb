class HomesController < ApplicationController

  def top
    @timeline = Post.all
  end
end
