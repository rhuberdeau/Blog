class CommentsController < ApplicationController
  before_filter :authenticate_user, :except => [:getall]
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = @post.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @article = @comment.article
  end

  # POST /comments
  # POST /comments.xml
  
  
  # POST /comments
  # POST /comments.xml
  def create
  	@comment = Comment.new(params[:comment])
    @comment.article_id = :article_id
    @comment.article_id = @comment.article_id.to_i
    @article = Article.find(@comment.article_id)
    @comment.name = current_user.username
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@article, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
        format.js 
        expire_action(:controller => 'articles', :action => 'show', :id => @article.id)
      else
        format.html { render 'articles/show', :object => @article }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  
  
  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    @article = @comment.article
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@article, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @article = @comment.article
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => 'admin', :action => 'manage_comments', :notice => 'Comment was successfully deleted') }
      format.xml  { head :ok }
    end
  end
  def getall
  	@comments = Comment.all(:order => "Created_at DESC")
  	respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
