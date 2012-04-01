class GroupEssayAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :group_essay
  belongs_to :group
end
