class Grade < ActiveRecord::Base
  belongs_to :gradable, :polymorphic => true
  belongs_to :student
  belongs_to :tutor

  validates :student_id, :presence => true
  validates :tutor_id, :presence => true
  validates_associated :tutor, :student

  def update_module_grade(stitch_unit, student, tutor)
    if stitch_unit.weight
      module_grade = Grade.where(:gradable_id => stitch_unit.stitch_module.id, :gradable_type => "StitchModule", :student_id => student, :tutor_id => tutor).first
      new_value = self.value * stitch_unit.weight / 100
      if module_grade.nil?
        grade = Grade.new(:gradable => stitch_unit.stitch_module, :student => student, :tutor => tutor, :value => new_value)
        grade.save
      else
        edit_value = module_grade.value + new_value
        module_grade.update_attribute(:value, edit_value)
        module_grade.save
      end
    else
      return false
    end
  end

  def calculate_course_grade(course, student, tutor)
    value = 0
    size = 0
    course.stitch_modules.each do |st|
      module_grade = Grade.where(:gradable_id => st.id, :gradable_type => "StitchModule", :student_id => student, :tutor_id => tutor ).first
      unless module_grade.nil?
        value += module_grade.value
        size += 1
      end
    end
    course_grade_value = value / size
    self.update_attribute(:value, course_grade_value)
    self.save
  end

end
