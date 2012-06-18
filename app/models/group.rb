class Group < ActiveRecord::Base
  has_many :enrollments
  has_many :students, :through => :enrollments
  has_many :channels
  belongs_to :tutor
  belongs_to :course
  has_one :deadline, :as => :deadlinable
  has_many :group_essay_answers
  
  belongs_to :parent_group, 
    :class_name => "Group",
    :foreign_key => 'parent_id'
      
  validates_associated :course, :tutor
  validates :tutor_id, :presence => true
  validates :course_id, :presence => true
  validates :title, :presence => true, :uniqueness => true, :length => {:minimum => 3, :maximum => 40}
  
  before_destroy :deletable?
  #before_save :enforce_logic
  
  scope :only_active, where(:active => true)
  
  def deletable?
    if enrollments == [] && all_students == []
      return true
    else   
      errors.add(:base, "cannot delete non empty groups")
      return false
    end
  end
  
  def self.find_group(page, student)
    group_id = student.groups.map {|g| g if g.course_id == page.course.id}.compact
    group = Group.find(group_id[0])
    return group
  end
  
  def all_students
    students = []
    students << self.students
    working_groups = Group.where(:parent_id => self.id)
    working_groups.map {|g| students << g.students}
    students.flatten
  end
  
  def meta_group
    return group = Group.find(self.parent_id) if self.parent_id
    return self
  end
  
  def meta_group?
    return true if self.parent_id
    return false    
  end

    
end
