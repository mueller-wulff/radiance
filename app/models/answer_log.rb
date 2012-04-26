class AnswerLog < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :course
  
  def self.find_and_destroy(student, tutor, page)
    log = AnswerLog.where(:student_id => student.id, :tutor_id => tutor.id, :page_id => page.id, :course_id => page.course.id).first
    log.destroy
  end
  
end
