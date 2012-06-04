class Tutor::DefaultAssesmentsController < ApplicationController
  before_filter :require_tutor
  before_filter :grab_course
  
  def show
    @default_assesments = DefaultAssesment.where(:course_id => @course.id, :tutor_id => @tutor.id).order("mark desc")
  end

  def new
    @default_assesments = Array.new(5) {DefaultAssesment.new}
  end

  def create
    @default_assesments = params[:default_assesments].values.collect { |default_assesment| DefaultAssesment.new(default_assesment) }
    if @default_assesments.all?(&:valid?)
      @default_assesments.each do |da|
        da.tutor = @tutor
        da.course = @course 
      end
      @default_assesments.each(&:save!)
      redirect_to assessment_tutor_course_path(@course)
    else
      render :action => "new"
    end
  end
  
  def grab_course
    @course = Course.find(params[:course_id])
    @tutor = current_user.role
  end

end
