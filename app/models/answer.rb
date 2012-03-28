class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :student
  
  before_save :check_deadline
  after_create :set_locked_false
  
  def save_multiple_answers(multianswers)
    hash = multianswers.select{|key, value| value == "1"}
    self.txt = ""
    hash.keys.each do |a|
      self.txt << a
      self.txt << "\n"
    end
  end
  
  def check_deadline
    return false if self.locked == true
    return false if deadline_reached?(self.question.page, self.student) 
  end
  
  protected
  
  def set_locked_false
    self.locked = false
    self.save
  end
  
  def deadline_reached?(page, student)
    today = Time.now
    deadline_group = student.groups.map {|g| g if g.course_id == page.course.id}
    if page.deadlines.empty?
      deadline = Deadline.where(:deadlinable_id => deadline_group).first
    else
      deadline = Deadline.where(:group_id => deadline_group[0], :deadlinable_id => page.id).first
    end
    unless deadline.nil?
      return true if deadline.due_date < today
    end
    return false
  end
  
end
