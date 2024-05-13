class ListsController < ApplicationController
  def update
    list = List.find(params[:id])
    list.update(list_params)
    redirect_to posts_path
  end

  def move_higher
    List.find(params[:id]).move_higher
    redirect_to posts_path
  end

  def move_lower
    List.find(params[:id]).move_lower
    redirect_to posts_path
  end

  private

  def list_params
    params.require(:list).permit(:checked)

  end
end
