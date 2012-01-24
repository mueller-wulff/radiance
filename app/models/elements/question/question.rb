class Question < Element  
  set_table_name :questions
  before_create :fill_with_default_content
  
  def fill_with_default_content
    self.txt ||= "Please enter a Question"
    self.answers ||= "Answer A\nAnswer B"
  end
  
  def answer_list
    self.answers.split("\n")
  end
end
