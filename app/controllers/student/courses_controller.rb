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
    @meta_group = @student.groups.where(:course_id => @course.id).first.meta_group
    @working_group = @student.groups.where(:course_id => @course.id).first
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def show_coursebook
    @course = Course.find(params[:id])
    @group = @student.find_tutor_of_course(@course)
    @tutor = @group.tutor
    @stitch_modules = @course.stitch_modules.all
    @course_grade = Grade.where(:gradable_id => @course.id, :gradable_type => "Course", :student_id => @student, :tutor_id => @tutor ).first
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
