class Developer::CoursesController < ApplicationController
  
  before_filter :require_developer
  # GET /courses
  # GET /courses.xml
  def index
    @courses = current_user.role.courses
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

end
