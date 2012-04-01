class GroupEssay < Element
  set_table_name :group_essays
  has_many :group_essay_answers
  
  before_create :fill_with_default_content
  
  def fill_with_default_content
    self.txt ||= "Please enter a Question"
  end
  
  def current_version
    return self.group_essay_versions.where(:current => true).first
  end
  
end
