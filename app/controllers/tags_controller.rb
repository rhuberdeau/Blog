class TagsController < ApplicationController
  allow_unauthenticated_access
  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.articles.published.order(published_at: :desc)
  end
end
