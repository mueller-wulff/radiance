class StitchModule < ActiveRecord::Base
  has_many :stitch_units, :order => "position"
  has_many :pages, :through => :stitch_units
  has_many :grades, :as => :gradeable
  belongs_to :course
  has_and_belongs_to_many :developers
  before_create :set_position
  
  validates :title, 
    :presence => true#,
  #:uniqueness => true
            
  def set_position
    if self.course.stitch_modules == []
      self.position = 1
    else
      self.position = self.course.stitch_modules.last.position + 1
    end
  end
  
  def deletable?
    #can only be deleted if truly empty
    if self.stitch_units == []
      return true
    else
      errors.add(:base, "cannot delete an non empty module")
      return false
    end
  end
  
  def order_units( order )
    transaction do
      order.each_with_index do |unit_id,index|
        sunit = self.stitch_units.find(unit_id)
        sunit.update_attribute(:position, index+1)
      end
    end
  end
  
  def last_page
    self.stitch_units.last.pages.last
  end

end