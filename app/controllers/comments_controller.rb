class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
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
  	@article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    
    if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
      @notice = "captcha incorrect"
      respond_to do |format|
        format.html { render :template => "articles/show", :notice => 'There was an error with the recaptcha. Please re-enter and submit.' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    elsif
      respond_to do |format|
        if @comment.save
          format.html { redirect_to(@article, :notice => 'Comment was successfully created.') }
          format.xml  { render :xml => @article, :status => :created, :location => @article }
        else
          format.html { render :template => "articles/show", :notice => 'There was an error with the recaptcha. Please re-enter and submit.' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
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
      format.html { redirect_to(@article, :notice => 'Comment was successfully deleted') }
      format.xml  { head :ok }
    end
  end
end
