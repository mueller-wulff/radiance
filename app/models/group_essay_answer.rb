class GroupEssayAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :group_essay
  belongs_to :group
  
  def self.answered_by_group?(student, element)
    group = student.find_tutor_of_course(element.content.page.course)
    return true unless GroupEssayAnswer.where(:group_id => group.id, :group_essay_id => element.id).empty?
    return false
  end
  
end
