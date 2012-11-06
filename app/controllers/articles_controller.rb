class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :about, :contact, :archive]
  caches_action :index, :show
  # GET /articles
  # GET /articles.xml
    
  def index
    @articles = Article.published.page(params[:page]).per(5).ordered
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comment.article_id = @article.id
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
  	@title = "Contact me- Robert Huberdeau"
  end
  
  def about
  	@users = User.approved
  	@title = "About me- Robert Huberdeau"
  end
  
  def archive
  	#@articles = Article.published
  	#@article_months = @articles.group_by { |a| a.created_at.beginning_of_month }
  	date = params[:year] + (params[:month] ? '-' + params[:month] : '') + (params[:day] ? '-' + params[:day] : '') + '%'
    @articles = Article.all(:conditions => ['created_at like ? and published = ?', date, true])
    @size = @articles.size
  end
  
  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    authorize! :create, @article
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
