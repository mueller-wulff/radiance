class Tutor::DeadlinesController < ApplicationController
  before_filter :grab_course
  
  def index
    @pages = @course.all_assignment_pages
    @groups = @course.groups.where(:tutor_id => @tutor.id)
  end
  
  def edit
    @deadline = Deadline.find(params[:id])
  end
  
  def update
    @deadline = Deadline.find(params[:id])
    tmp_date = DateTime.new( params[:deadline]["due_date(1i)"].to_i, params[:deadline]["due_date(2i)"].to_i, params[:deadline]["due_date(3i)"].to_i, params[:deadline]["due_date(4i)"].to_i, params[:deadline]["due_date(5i)"].to_i )
    @deadline.update_attribute(:due_date, tmp_date)
    redirect_to tutor_course_deadlines_path(@course)
  end
  
  def grab_course
    @course = Course.find(params[:course_id])  
    @tutor = current_user.role  
  end

end
