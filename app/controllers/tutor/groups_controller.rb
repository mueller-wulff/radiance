class Tutor::GroupsController < ApplicationController
  before_filter :require_user
  before_filter :grab_tutor_id
  # GET /groups
  # GET /groups.xml
  def index
    @groups = @tutor.groups.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = @tutor.groups.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = @tutor.groups.new
    @courses = Course.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = @tutor.groups.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = @tutor.groups.new(params[:group])
    @group.course_id = params[:courses]
    respond_to do |format|
      if @group.save
        format.html { redirect_to(tutor_groups_url, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = @tutor.groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(tutor_groups_url, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = @tutor.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(tutor_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def grab_tutor_id
    @tutor = Tutor.find(params[:tutor_id])
  end
    
end
