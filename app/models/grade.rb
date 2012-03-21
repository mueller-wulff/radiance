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
  
end
