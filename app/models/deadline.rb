class Deadline < ActiveRecord::Base
  belongs_to :deadlinable, :polymorphic => true
  validates_uniqueness_of :group_id, :scope => [:deadlinable_id, :deadlinable_type]
  
  before_create :check_group_deadline
  
  def self.find_course_deadlines(course)
    deadlines = []
    groups = course.groups.all
    groups.map {|g| deadlines << Deadline.where(:group_id => g.id) }
    deadlines.flatten!
  end 
  
  def check_group_deadline(tmp_date=nil)
    groupdeadline = Deadline.where(:deadlinable_id => self.group_id, :deadlinable_type => "Group").first
    if tmp_date == nil
      return false if groupdeadline.due_date < self.due_date
    else
      return false if groupdeadline.due_date < tmp_date
    end
    return true
  end
    
end
