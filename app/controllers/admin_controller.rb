class AdminController < ApplicationController
  before_filter :authenticate_user!	
  def index
  	@articles = Article.all(:order => "Created_at DESC")
  end

  def show
  	 @article = Article.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

end
