class AdminController < ApplicationController
  def index
    @articles = Article.drafts.order(updated_at: :desc)
    @published_articles = Article.published.order(published_at: :desc)
  end
end
