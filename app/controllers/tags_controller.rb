class TagsController < ApplicationController
  def show
  	@tag = Tag.find(params[:id])
  	@articles = @tag.articles.published
  	@title = "Articles with tag #{@tag.name}"
  end

end
