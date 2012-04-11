class Deadline < ActiveRecord::Base
  belongs_to :deadlinable, :polymorphic => true
  validates_uniqueness_of :group_id, :scope => [:deadlinable_id, :deadlinable_type]
  
  def self.find_course_deadlines(course)
    deadlines = []
    groups = course.groups.all
    groups.map {|g| deadlines << Deadline.where(:group_id => g.id) }
    deadlines.flatten!
  end  
    
end
