class Content < ActiveRecord::Base
  acts_as_paranoid
    
  belongs_to :page
  belongs_to :element, :polymorphic => true
  accepts_nested_attributes_for :element
  acts_as_paranoid :dependent_recovery_window => 1.minute
  
  before_create :set_position
  
  #Paranoid behavoir!
  
  #after_destroy :destroy_element
  #
  #def destroy_element
  #  self.element.destroy
  #end
  
  def set_position
    unless self.position
      if self.page.contents
        self.position = 1
      else
        self.position = self.page.contents.last.position + 1
      end
    end
  end
  
  def copy_to_page(new_page)
    transaction do
      @copy = self.dup
      @copy.element = self.element.dup
      
      @copy.element.save!
      @copy.save!
      @copy.update_attribute(:page, new_page)      
    end
  end  
  
end
