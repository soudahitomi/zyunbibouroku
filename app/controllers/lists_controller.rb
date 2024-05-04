class ListsController < ApplicationController
  def update
    list = List.find(params[:id])
    list.update(list_params)
    redirect_to root_path
  end

  private

  def list_params
    params.require(:list).permit(:checked)

  end
end
