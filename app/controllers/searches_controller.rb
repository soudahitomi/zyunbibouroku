class SearchesController < ApplicationController
   before_action :authenticate_user!

  def search
    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    if @model  == "user"
      @records = User.search_for(@word, @method)
    else
      @records = Books.search_for(@word, @method)
    end
  end
end
