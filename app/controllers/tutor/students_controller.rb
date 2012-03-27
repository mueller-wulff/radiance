class Tutor::StudentsController < ApplicationController
  before_filter :require_user
  before_filter :grab_tutor, :except => [:edit, :update, :show]
  before_filter :grab_group_id, :except => [:edit, :update]
  # GET /students
  # GET /students.xml
  def index
    @students = Student.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end  
  
  def show
    @student = Student.find(params[:id])
    @assignments = @student.find_assignment_pages(@group)
    
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
    end
    respond_to do |format|
      if @student.save
        @student.groups << @group
        @student.send_new_group(@group)       
        format.html { redirect_to(edit_tutor_group_path(@tutor, @group), :notice => 'Student was successfully enrolled.') }
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
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
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
        format.html { redirect_to(edit_tutor_group_path(@tutor, @group), :notice => 'Student was successfully shuffled.') }
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
