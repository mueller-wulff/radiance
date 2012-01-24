class Grade < ActiveRecord::Base
  belongs_to :gradeable, :polymorphic => true
  belongs_to :student
  belongs_to :tutor
  
  validates :student_id, :presence => true
  validates :tutor_id, :presence => true
  validates_associated :tutor, :student
end
