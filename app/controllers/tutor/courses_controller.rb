class Tutor::CoursesController < ApplicationController
  before_filter :require_tutor
  
  def index
    @courses = current_user.role.courses
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :html => @courses, :layout => false } # js ajax
    end
  end

  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def overview
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def assessment
    @course = Course.find(params[:id])
    @students = @course.students(current_user.role)
    @stitch_modules = @course.stitch_modules

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def assignment
    @course = Course.find(params[:id])
    @stitch_modules = @course.stitch_modules
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
