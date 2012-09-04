class TutorialsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  # GET /tutorials
  # GET /tutorials.xml
  def index
    @tutorials = Tutorial.all
    @title = "A collection of Ruby on Rails tutorials"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tutorials }
    end
  end

  # GET /tutorials/1
  # GET /tutorials/1.xml
  def show
  	@tutorial = Tutorial.find_by_permalink(params[:id])
    @steps = @tutorial.steps
    @next = @steps[0]
    @title = "#{@tutorial.name} - A Ruby on Rails tutorial"
    @content = "Building a forum application from scratch using Ruby on Rails 3"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tutorial }
    end
  end

  # GET /tutorials/new
  # GET /tutorials/new.xml
  def new
    @tutorial = Tutorial.new
	@title = "New tutorial"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tutorial }
    end
  end

  # GET /tutorials/1/edit
  def edit
  	@tutorial = Tutorial.find_by_permalink(params[:id])
  	authorize! :edit, @tutorial
  end

  # POST /tutorials
  # POST /tutorials.xml
  def create
    @tutorial = Tutorial.new(params[:tutorial])
    authorize! :create, @tutorial
    respond_to do |format|
      if @tutorial.save
        format.html { redirect_to(@tutorial, :notice => 'Tutorial was successfully created.') }
        format.xml  { render :xml => @tutorial, :status => :created, :location => @tutorial }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tutorial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tutorials/1
  # PUT /tutorials/1.xml
  def update
    @tutorial = Tutorial.find_by_permalink(params[:id])
    authorize! :update, @tutorial
    respond_to do |format|
      if @tutorial.update_attributes(params[:tutorial])
        format.html { redirect_to(@tutorial, :notice => 'Tutorial was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tutorial.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorials/1
  # DELETE /tutorials/1.xml
  def destroy
    @tutorial = Tutorial.find_by_permalink(params[:id])
    @tutorial.destroy
    authorize! :destroy, @tutorial

    respond_to do |format|
      format.html { redirect_to(tutorials_url) }
      format.xml  { head :ok }
    end
  end
end
