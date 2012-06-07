class Student < Role
  set_table_name :students
  
  has_many :grades
  has_many :notes
  has_many :enrollments, :dependent => :delete_all
  has_many :groups, :through => :enrollments
  has_many :answers
  has_many :group_essay_versions
  
  before_destroy :deletable?
  #before_save :enforce_logic
  
  def deletable?
    #can only be deleted if not yet activated
    !self.activated
  end
  
  # nicht mit hmt vereinbar
  def enforce_logic
    if self.groups == []
      errors.add(:base, "student must have at least one group")
      return false
    end
    if self.profile == nil
      errors.add(:base, "student must have a profile")
      return false
    end
  end
  
  #TODO implement
  def activate
    self.update_attribute(:activated, true)
  end
 
  def courses
    groups = enrollments.map{|e|e.group}
    groups.map{|g| g.course}
  end
  
  def find_tutor_of_course(course)
    group = self.groups.where(:course_id => course.id).first
    return group
  end
  
  def shuffle_group(old_group, new_group)
    self.groups.delete(old_group)
    self.groups << new_group 
    send_new_group(new_group)   
  end
  
  def send_new_group(group)
    Notifier.new_group(self, group).deliver
  end
    
  def create_coursebook(tutor, course)
    self.grades.create(:tutor => tutor, :gradable => course, :value => 0.0)
  end
  
  def give_answer?(student, element)
    return true if Answer.where(:student_id => student.id, :question_id => element.id).first
    return false
  end
  
  def course_group(course, tutor)
    return Group.where(:course_id => course.id, :tutor_id => tutor.id, :parent_id => nil).first
  end
  
end
