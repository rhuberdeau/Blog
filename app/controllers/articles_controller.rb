class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :user_must_be_admin, :except => [:index, :show]
  respond_to :html, :json

  def index
    @articles = Article.where(:published => true).paginate(:page => params[:page]).order('id DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  def show
    @article          = Article.find(params[:id])

    if @article 
      id                = params[:id].split('-').first
      @previous_article = Article.where("id < ?", id).order("created_at").first
      @next_article     = Article.where("id > ?", id).order("created_at").first

      set_meta_tags title: "#{@article.title} | Robert Huberdeau"
      set_meta_tags  description: @article.summary
      set_meta_tags og: {
        title: @article.title,
        type: 'article',
      }
    end
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
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
  
  private
  
    def article_params
      params.require(:article).permit(:title, :body, :tag_names, :published, :summary, :sequence_id, :cached_slug)
    end
end
