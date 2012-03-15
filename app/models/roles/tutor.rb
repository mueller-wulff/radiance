class Tutor < Role
  set_table_name :tutors
  
  has_many :groups
  has_and_belongs_to_many :courses
  has_many :question_scores
  
  def metagroup(group)
    self.groups.map {|g| g if g.course_id == group.course_id}.compact
  end
  
  # TODO if admin remove a course from tutor, check if course has group
  # def check_course
  #     
  #   end  
    
end
