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
  
  private
  
  def grab_student
    @student = current_user.role
  end

end
