class Tutor::DeadlinesController < ApplicationController
  before_filter :grab_course
  before_filter :demo_tutor_not_allowed, :except => :index

  def index
    @pages = @course.all_assignment_pages
    @groups = @course.groups.where(:tutor_id => @tutor.id, :parent_id => nil)
  end

  def new
    @deadline = Deadline.new
    @group_deadline = Deadline.find(params[:group_deadline])
    @group = Group.find(params[:group_id])
    @page = Page.find(params[:page])
  end

  def edit
    @deadline = Deadline.find(params[:id])
    @deadline.group_id.nil? ? @group_deadline = @deadline : @group_deadline = Deadline.where(:deadlinable_id => @deadline.group_id, :deadlinable_type => "Group").first
  end

  def create
    @deadline = Deadline.new(params[:deadline])
    @page = Page.find(params[:page])
    @deadline.deadlinable = @page
    @deadline.group_id = params[:group_id]
    respond_to do |format|
      if @deadline.save
        format.html {redirect_to(tutor_course_deadlines_path(@course) ) }
      else
        format.html { redirect_to(new_tutor_course_deadline_path(@course, :group_id => params[:group_id], :page => params[:page], :group_deadline => params[:group_deadline] ) ) }
      end
    end
  end

  def update
    @deadline = Deadline.find(params[:id])
    tmp_date = DateTime.new( params[:deadline]["due_date(1i)"].to_i, params[:deadline]["due_date(2i)"].to_i, params[:deadline]["due_date(3i)"].to_i, params[:deadline]["due_date(4i)"].to_i, params[:deadline]["due_date(5i)"].to_i )
    if @deadline.group_id.nil?
      @deadline.update_attribute(:due_date, tmp_date)
    else
      if @deadline.check_group_deadline(tmp_date)
        @deadline.update_attribute(:due_date, tmp_date)
      end
    end
    redirect_to tutor_course_deadlines_path(@course)
  end

  def grab_course
    @course = Course.find(params[:course_id])
    @tutor = current_user.role
  end

end
