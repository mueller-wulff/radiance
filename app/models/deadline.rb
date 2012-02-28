class Deadline < ActiveRecord::Base
  belongs_to :deadlinable, :polymorphic => true
end
