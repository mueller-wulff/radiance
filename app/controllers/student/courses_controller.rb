class Student::CoursesController < ApplicationController
  before_filter :require_student
  before_filter :grab_student
  
  def index
    @courses = @student.courses
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
  
  def show_coursebook
    @course = Course.find(params[:id])
    @tutor = @student.find_tutor_of_course(@course)
    @stitch_modules = @course.stitch_modules.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @students }
    end
  end
  
  private
  
  def grab_student
    @student = current_user.role
  end

end
