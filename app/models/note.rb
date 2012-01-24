class Note < ActiveRecord::Base
  belongs_to :page
  belongs_to :student
  validates :text,
    :presence => true
  validates :user,
    :presence => true
end
