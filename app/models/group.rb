class Group < ActiveRecord::Base
  has_many :enrollments
  has_many :students, :through => :enrollments
  has_many :channels
  belongs_to :tutor
  belongs_to :course
  has_one :deadline, :as => :deadlinable
  has_many :group_essay_answers
      
  validates_associated :course, :tutor
  validates :tutor_id, :presence => true
  validates :course_id, :presence => true
  validates :title, :presence => true, :uniqueness => true, :length => {:minimum => 3, :maximum => 40}
  
  before_destroy :deletable?
  #before_save :enforce_logic
  
  def deletable?
    if enrollments == []
      return true
    else   
      errors.add(:base, "cannot delete non empty groups")
      return false
    end
  end
  
  def self.find_group(page, student)
    group_id = student.groups.map {|g| g if g.course_id == page.course.id}
    group = Group.find(group_id[0])
    return group
  end
    
end
