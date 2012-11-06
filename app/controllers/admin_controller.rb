class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_must_be_admin	
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
  
  private
  
  def user_must_be_admin
  	@user = current_user
  	unless @user.role_ids == 1
  	  redirect_to(articles_path)
  	end
  end

end
