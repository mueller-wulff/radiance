class Admin::DevelopersController < ApplicationController

  before_filter :require_admin
  # GET /developers
  # GET /developers.xml
  def index
    @developers = Developer.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /developers/new
  # GET /developers/new.xml
  def new
    @developer = Developer.new
    @profile = @developer.build_profile
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /developers/1/edit
  def edit
    @developer = Developer.find(params[:id])
    @profile = @developer.profile
    @courses = Course.all
  end

  # POST /developers
  # POST /developers.xml
  def create
    @developer = Developer.new(params[:developer])
    @profile = @developer.profile
    respond_to do |format|
      if @developer.save
        format.html { redirect_to(admin_developers_path, :notice => 'Developer was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /developers/1
  # PUT /developers/1.xml
  def update
    params[:developer][:stitch_module_ids] ||= []
    @developer = Developer.find(params[:id])
    @courses = Course.all
    respond_to do |format|
      if @developer.update_attributes(params[:developer])
        format.html { redirect_to(admin_developers_path, :notice => 'Developer was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /developers/1
  # DELETE /developers/1.xml
  def destroy
    @developer = Developer.find(params[:id])
    @developer.destroy

    respond_to do |format|
      format.html { redirect_to(admin_developers_path) }
    end
  end
end
