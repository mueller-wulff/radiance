class Admin::StitchModulesController < ApplicationController
  before_filter :require_admin
  before_filter :get_course
  
  def get_course    
    @course = Course.find(params[:course_id])      
  end



  # GET /stitch_modules/new
  # GET /stitch_modules/new.xml
  def new
    @stitch_module = @course.stitch_modules.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /stitch_modules/1/edit
  def edit
    @stitch_module = @course.stitch_modules.find(params[:id])
  end

  # POST /stitch_modules
  # POST /stitch_modules.xml
  def create
    @stitch_module = @course.stitch_modules.new(params[:stitch_module])

    respond_to do |format|
      if @stitch_module.save
        format.html { redirect_to(admin_course_path(@course), :notice => t(:stitch_module, :scope => :stitch_module)+" "+t(:successfully_created, :scope => :general)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /stitch_modules/1
  # PUT /stitch_modules/1.xml
  def update
    @stitch_module = @course.stitch_modules.find(params[:id])

    respond_to do |format|
      if @stitch_module.update_attributes(params[:stitch_module])
        format.html { redirect_to(admin_course_path(@course), :notice => t(:stitch_module, :scope => :stitch_module)+" "+t(:successfully_updated, :scope => :general)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /stitch_modules/1
  # DELETE /stitch_modules/1.xml
  def destroy
    @stitch_module = @course.stitch_modules.find(params[:id])
    @stitch_module.destroy

    respond_to do |format|
      format.html { redirect_to(admin_course_path(@course)) }
    end
  end
end
