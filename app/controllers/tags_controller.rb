class TagsController < ApplicationController
  def show
  	@tag = Tag.find(params[:id])
  	@articles = @tag.articles.published
  end

end
