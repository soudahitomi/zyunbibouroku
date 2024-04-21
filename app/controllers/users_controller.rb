class UsersController < ApplicationController

  def update
    @user = User.find(params[:id])
    @user.update
    redirect_to root_path
  end
  
  def edit
    @user = User.find(params[:id])
  end
end
