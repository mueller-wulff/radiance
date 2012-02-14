class Tutor < Role
  set_table_name :tutors
  
  has_many :groups
  
  def metagroup(group)
    self.groups.map {|g| g if g.course_id == group.course_id}.compact
  end
    
end
