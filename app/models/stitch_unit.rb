class StitchUnit < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :stitch_module
  has_many :pages, :dependent => :destroy, :order => "position"
  has_many :grades, :as => :gradable
  
  before_create :fill_with_default_content
  
  def fill_with_default_content
    self.title ||= "new Unit"
    unless self.position
      if self.stitch_module.stitch_units == []
        self.position = 1
      else
        self.position = self.stitch_module.stitch_units.last.position + 1
      end
    end
  end
  
  
  def order_pages( order )
    transaction do
      order.each_with_index do |page_id,index|
        page = self.pages.find(page_id)
        page.update_attribute(:position, index+1)
      end
    end
  end
  
  def copy_to_module(new_module)
    transaction do
      @copy = self.dup
      @copy.save!
      @copy.update_attribute(:stitch_module, new_module)
      
      #trigger content copy
      self.pages.each do |page|
        page.copy_to_unit(@copy)
      end
      
    end
    return @copy || false
  end
  
  def course
    self.stitch_module.course
  end
  
  def has_assignment_page?
    self.pages.map {|p| return true if p.assignment == true}
    return false
  end
  
end
