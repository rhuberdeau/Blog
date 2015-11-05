class AdminController < ApplicationController
  before_filter :authenticate_user
  before_filter :user_must_be_admin	
  
  def index
  	@articles = Article.all(:order => "Created_at DESC")
    render(:layout => "layouts/admin")
  end

  def show
  	 @article = Article.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end
  
  def manage_comments
  	@comments = Comment.all
  end
end
