class Public::SearchesController < ApplicationController

  def search
    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    if @model  == "user"
      @records = User.search_for(@word, @method)
    else
      @records = Post.search_for(@word, @method)
    end
  end
end
