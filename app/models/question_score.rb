class QuestionScore < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :question
end
