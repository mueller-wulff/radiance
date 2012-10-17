class Tutor::StudentsController < ApplicationController
  before_filter :require_user
  before_filter :grab_tutor, :except => [:edit, :update,]
  before_filter :grab_group_id, :except => [:edit, :update, :index, :destroy]
  # GET /students
  # GET /students.xml
  def index
    @course = Course.find(params[:course_id]) if params[:course_id]
    @course_groups = @course.groups.where(:tutor_id => @tutor.id, :parent_id => nil)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end  
  
  def show
    @student = Student.find(params[:id])
    @stitch_modules = StitchModule.where(:course_id => @group.course.id).order(:position)
    @course_grade = Grade.where(:gradable_id => @group.course.id, :gradable_type => "Course", :student_id => @student, :tutor_id => @tutor ).first
    respond_to do |format|
      format.html # show.html.erb
      format.js { head :ok }
      format.xml  { render :xml => @students }
    end
  end

  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    @profile = @student.build_profile
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # POST /students
  # POST /students.xml
  def create
    if Profile.find_by_email(params[:student]["profile_attributes"]["email"]).nil?
      @student = Student.new(params[:student])
      @profile = @student.profile
      @profile.login = params[:student]["profile_attributes"]["email"]
    else
      @profile = Profile.find_by_email(params[:student]["profile_attributes"]["email"])
      @student = @profile.role
      unless @profile.role.class == Student
        flash[:error] = "email already in use" 
      end
    end
    respond_to do |format|
      if @student.save
        @student.groups << @group
        @student.send_new_group(@group)
        @student.create_coursebook(@tutor, @group.course)
        format.html { redirect_to(tutor_course_students_path(@group.course), :notice => t(:enrolled, :scope => :student)) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @course = Course.find(params[:course_id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(tutor_course_students_path(@course)) }
      format.xml  { head :ok }
    end
  end
  
  def shuffle
    @student = Student.find(params[:id])    
  end
  
  def update_shuffle
    @student = Student.find(params[:id]) 
    new_group = Group.find(params[:metagroup])
    @student.shuffle_group(@group, new_group)
    respond_to do |format|
      if @student.save        
        @student.send_new_group(new_group)
        format.html { redirect_to(edit_tutor_group_path(@group.parent_group), :notice => t(:shuffled, :scope => :student) ) }
      else
        format.html { render :action => "shuffle" }
      end
    end
  end

  private

    def grab_tutor
      @tutor = current_user.role
    end

    def grab_group_id
      @group = Group.find(params[:group_id])
    end

end
