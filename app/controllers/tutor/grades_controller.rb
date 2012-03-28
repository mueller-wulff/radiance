class Tutor::GradesController < ApplicationController
  before_filter :require_tutor

  before_filter :grab_data

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
    @grade.student = @student
    @grade.tutor = @group.tutor
    @stitch_unit = StitchUnit.find(params[:stitch_unit])
    @grade.gradable = @stitch_unit
    @grade.value = params[:grade]
    if @grade.save
      @grade.update_module_grade(@stitch_unit, @student, @group.tutor)
    end
    redirect_to tutor_group_student_path(@group, @student, :format => 'html')
  end

  # only for calculation of course grade
  def update
    @grade = Grade.find(params[:id])
    @grade.calculate_course_grade(@group.course, @student, current_user.role)
    redirect_to tutor_group_student_path(@group, @student)
  end

  def grab_data
    @student = Student.find(params[:student])
    @group = Group.find(params[:group])
  end

end
