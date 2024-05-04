class HomesController < ApplicationController
  before_action :authenticate_user!
  
  def top
    @posts = current_user.posts
  end
end
