class Developer::StitchModulesController < ApplicationController
  before_filter :require_developer
  before_filter :get_course, :only => [:edit, :update]

  def get_course    
    @course = Course.find(params[:course_id])      
  end

  
  def index
    @modules = current_user.role.stitch_modules
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /stitch_modules/1
  # GET /stitch_modules/1.xml
  def show
    @stitch_module = StitchModule.find(params[:id])
    @pages = @stitch_module.pages
    @open_unit = @stitch_module.stitch_units.find(params[:stitch_unit_id]) if params[:stitch_unit_id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /stitch_modules/1/edit
  def edit
    @stitch_module = @course.stitch_modules.find(params[:id])
  end

  # PUT /stitch_modules/1
  # PUT /stitch_modules/1.xml
  def update
    @stitch_module = @course.stitch_modules.find(params[:id])

    respond_to do |format|
      if @stitch_module.update_attributes(params[:stitch_module])
        format.html { redirect_to(developer_course_path(@course), :notice => t(:updated, :scope => :stitch_module)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
end
