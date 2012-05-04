class Tutor < Role
  set_table_name :tutors
  
  has_many :groups
  has_and_belongs_to_many :courses
  has_many :question_scores
  has_many :default_assesments
  has_many :answer_logs
  
  def metagroup(group)
    self.groups.map {|g| g if g.course_id == group.course_id && g.parent_id }.compact
  end
  
  # TODO if admin remove a course from tutor, check if course has group
  # def check_course
  #     
  #   end  
    
end
