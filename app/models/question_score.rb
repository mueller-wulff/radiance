class QuestionScore < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :scoreable, :polymorphic => true
end
