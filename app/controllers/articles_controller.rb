class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :about, :contact, :archive]
  # GET /articles
  # GET /articles.xml
    
  def index
    @articles = Article.published.paginate :page => params[:page], :per_page => 5, :include => :user, :order => "Created_at DESC", :select => 'id, title, body, created_at, published, user_id' 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    @title = @article.title
    @content = @article.summary
    @keywords = @article.title
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end
  
  def contact
  	@article = Article.first(:conditions => ['title = ?', "Contact"])
  end
  
  def about
  	@users = User.approved
  end
  
  def archive
  	@articles = Article.published
  	@article_months = @articles.group_by { |a| a.created_at.beginning_of_month }
  end
  
  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    authorize! :edit, @article
  end

  # POST /articles
  # POST /articles.xml
  def create
  	@article = Article.new(params[:article])
    @article.user_id = current_user.id
    @article.published = "false"
    authorize! :create, @article
         
    respond_to do |format|
      if @article.save
      	expire_fragment('all_tags')
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    authorize! :update, @article
    
    respond_to do |format|
      if @article.update_attributes(params[:article])
      	expire_fragment('all_tags')
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    authorize! :destroy, @article

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
      
end
