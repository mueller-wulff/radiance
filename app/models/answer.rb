class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :student
    
  def save_multiple_answers(multianswers)
    hash = multianswers.select{|key, value| value == "1"}
    self.txt = ""
    hash.keys.each do |a|
      self.txt << a
      self.txt << "\n"
    end
  end
  
end
