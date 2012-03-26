class Grade < ActiveRecord::Base
  belongs_to :gradable, :polymorphic => true
  belongs_to :student
  belongs_to :tutor
  
  validates :student_id, :presence => true
  validates :tutor_id, :presence => true
  validates_associated :tutor, :student
  
  def update_module_grade(stitch_unit, student, tutor)
    module_grade = Grade.where(:gradable_id => stitch_unit.stitch_module.id, :gradable_type => "StitchModule", :student_id => student, :tutor_id => tutor)
    new_value = self.value * stitch_unit.weight / 100
    if module_grade.empty?
      grade = Grade.new(:gradable => stitch_unit.stitch_module, :student => student, :tutor => tutor, :value => new_value)
      grade.save
    else
      grade = Grade.find(module_grade)
      edit_value = grade.value + new_value
      grade.update_attribute(:value, edit_value)
      grade.save
    end
  end
  
  def self.calculate_course_grade(course, student, tutor)
    value = 0
    course.stitch_modules.each do |st|
      module_grade = Grade.where(:gradable_id => st.id, :gradable_type => "StitchModule", :student_id => student, :tutor_id => tutor )
      unless module_grade.empty?
        grade = Grade.find(module_grade)
        value += grade.value
      end
    end
    course_grade_value = value / course.stitch_modules.size
    course_grade = Grade.where(:gradable_id => course.id, :gradable_type => "Course", :student_id => student, :tutor_id => tutor )
    grade = Grade.find(course_grade)
    grade.update_attribute(:value, course_grade_value)
    grade.save
  end
  
end
