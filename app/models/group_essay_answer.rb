class GroupEssayAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :group_essay
  belongs_to :group
  
  def self.answered_by_group?(student, element)
    group = student.find_tutor_of_course(element.content.page.course)
    return true unless GroupEssayAnswer.where(:group_id => group.id, :group_essay_id => element.id).empty?
    return false
  end
  
  def self.submit_group_essay(group, page)
    group_essays = page.contents.where(:element_type => "GroupEssay")
    group_essays.each do |e|
      group_essay = GroupEssay.find(e.element_id)
      answer = group_essay.group_essay_answers.where(:group_id => group.id).first
      if answer.nil?
        answer = GroupEssayAnswer.new
        answer.group = group
        answer.group_essay = group_essay
        answer.txt = "No Answer given"
      end
      answer.locked = true
      answer.save
    end
  end
  
end
