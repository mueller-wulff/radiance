class Question < Element  
  set_table_name :questions
  
  has_many :answers
  
  accepts_nested_attributes_for :answers 
  
  before_create :fill_with_default_content
  
  def fill_with_default_content
    self.txt ||= "Please enter a Question"
  end
  
  def answer_list
    self.answers.split("\n")
  end
end
