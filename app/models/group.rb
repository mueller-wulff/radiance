class Group < ActiveRecord::Base
  has_many :enrollments
  has_many :students, :through => :enrollments
  belongs_to :tutor
  belongs_to :course
      
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
    
end
