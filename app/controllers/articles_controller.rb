class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :archive, :related]
  before_filter :user_must_be_admin, :except => [:index, :show, :archive, :related]
  caches_action :show
  respond_to :html, :json

  def index
    @articles = Article.where(:published => true).paginate(:page => params[:page]).order('id DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

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
  
  def archive
  	#@articles = Article.published
  	#@article_months = @articles.group_by { |a| a.created_at.beginning_of_month }
  	date = params[:year] + (params[:month] ? '-' + params[:month] : '') + (params[:day] ? '-' + params[:day] : '') + '%'
    @articles = Article.all(:conditions => ['created_at like ? and published = ?', date, true])
    @size = @articles.size
  end
  
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
  end

  def create
  	@article = current_user.articles.build(article_params)
            
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
  
  def update
    @article = Article.find(params[:id])
        
    respond_to do |format|
      if @article.update_attributes(article_params)
      	expire_fragment('all_tags')
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  def related
    @article = Article.find(params[:id])
    @related = Article.where("sequence_id = ?", @article.sequence_id).select("id, title, cached_slug").order('id ASC')
    respond_with @related.to_json
  end
  
  private
  
    def article_params
      params.require(:article).permit(:title, :body, :tag_names, :published, :summary, :sequence_id, :cached_slug)
    end
end
