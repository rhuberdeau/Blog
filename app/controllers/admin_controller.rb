class AdminController < ApplicationController
  def index
    @articles = Article.where(published: false)
    @published_articles = Article.where(published: true)
  end
end
