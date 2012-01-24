class Student < Role
  set_table_name :students
  
  has_many :grades
  has_many :notes
  has_many :enrollments, :dependent => :delete_all
  has_many :groups, :through => :enrollments
  
  before_destroy :deletable?
  before_save :enforce_logic
  
  def deletable?
    #can only be deleted if not yet activated
    !self.activated
  end
  
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
end
