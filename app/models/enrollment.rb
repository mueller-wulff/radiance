class Enrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :group
  
  validates :student_id, :presence => true, :uniqueness => {:scope => :group_id, :message => "student can only enroll in a course once"}
  validates :group_id, :presence => true
  validates_associated :student, :group
  
  before_save :double_enrollments
  before_destroy :deletable?
  
  def double_enrollments
    if student.courses.include?(group.course)
      errors.add(:Student, "student can only enroll in a course once")
      return false
    else
      true
    end
  end

  def deletable? 
    errors.add(:base, "cannot unenroll activated student")
    return false
  end
  
end
