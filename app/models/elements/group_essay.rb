class GroupEssay < Element
  set_table_name :group_essays
  before_create :fill_with_default_content
  
  def fill_with_default_content
    self.txt ||= "Please enter a Question"
  end
  
end
