class StepsController < ApplicationController
  before_filter :authenticate_user, :except => [:index, :show,]
  before_filter :user_must_be_admin, :except => [:index, :show,]
  # GET /steps
  # GET /steps.xml
  before_filter :find_tutorial, :except => [:update]
  def index
    @steps = Step.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
  	@step = Step.find(params[:id])
  	
  	respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
  	@step = Step.new(:tutorial=>@tutorial)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
  	@step = Step.find(params[:id])
  	authorize! :edit, @step
  end

  # POST /steps
  # POST /steps.xml
  def create
  	@step = @tutorial.steps.build(params[:step])
    
    respond_to do |format|
      if @step.save
        format.html { redirect_to(@tutorial, :notice => 'Step was successfully created.') }
        format.xml  { render :xml => @tutorial, :status => :created, :location => @tutorial }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = Step.find(params[:id])
    @tutorial = @step.tutorial
    
    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to(@tutorial, :notice => 'Step was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = Step.find(params[:id])
    @step.destroy
    
    respond_to do |format|
      format.html { redirect_to(@tutorial) }
      format.xml  { head :ok }
    end
  end
  
  def find_tutorial
  	@tutorial = Tutorial.find_by_permalink(params[:tutorial_id])
  end
end
