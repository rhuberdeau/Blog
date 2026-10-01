class SitemapController < ApplicationController
  allow_unauthenticated_access
  layout nil

  def index
    @articles = Article.published
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
