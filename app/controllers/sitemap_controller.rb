class SitemapController < ApplicationController
  layout nil

  def index
    @articles = Article.where(published: true)
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
