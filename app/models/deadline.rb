class Deadline < ActiveRecord::Base
  belongs_to :deadlinable, :polymorphic => true
  validates_uniqueness_of :group_id, :scope => [:deadlinable_id, :deadlinable_type]
  
  
    
end
