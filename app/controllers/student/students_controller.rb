class Student::StudentsController < ApplicationController
  before_filter :require_student
  before_filter :demo_student_not_allowed, :only => [:edit, :update]
  
  def index
    @course = Course.find(params[:course_id])
    @group = current_user.role.find_tutor_of_course(@course)
    @course_group = @group.meta_group if @group.parent_id
    @students = @group.all_students
    @course_students = @course_group.all_students if @course_group
    @tutor = @group.tutor
  end
  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
    @profile = @student.profile
  end
  
  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])
    @profile = @student.profile
    @student.activate unless @student.activated
    respond_to do |format|
      if @student.update_attributes(params[:student]) 
        format.html { redirect_to(root_url, :notice => t(:updated, :scope => :student )) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
end
