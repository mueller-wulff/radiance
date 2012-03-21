class Tutor::GradesController < ApplicationController
  before_filter :require_tutor
  
  def index
    @gradable = find_gradable
    @grades = @gradeable.grades
  end
  
  def find_gradable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  # only for grades of type stitch_unit
  def create
    @grade = Grade.new
    @student = Student.find(params[:student])
    @grade.student = @student
    @group = Group.find(params[:group])
    @grade.tutor = @group.tutor  
    @stitch_unit = StitchUnit.find(params[:stitch_unit])
    @grade.gradable = @stitch_unit
    @grade.value = params[:grade]
    respond_to do |format|
      if @grade.save
        @grade.update_module_grade(@stitch_unit, @student, @group.tutor)
        format.html {tutor_group_student_path(@group, @student) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end
