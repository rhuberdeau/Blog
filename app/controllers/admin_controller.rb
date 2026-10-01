class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :user_must_be_admin

  def index
    @articles = Article.where(published: false)
    @published_articles = Article.where(published: true)
  end
end
