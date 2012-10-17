class Admin::CoursesController < ApplicationController
  before_filter :require_admin
  # GET /courses
  # GET /courses.xml
  def index
    @published = Course.where(:published => true)
    @unpublished = Course.where(:published => false)
    @deprecated = Course.where(:deprecated => true)
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :html => @courses, :layout => false } # js ajax
    end
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end
  
  def clone
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to(admin_courses_path, :notice => t(:course_created, :scope => :course)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to(admin_courses_path, :notice => t(:course_updated, :scope => :course)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def update_clone
    @course = Course.find(params[:id])
    respond_to do |format|
      if @course.clone_course(params[:course])  
        format.html { redirect_to(admin_courses_path, :notice => t(:course_cloned, :scope => :course)) }
      else
        format.html { render :action => "clone" }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(admin_courses_path) }
    end
  end
end
