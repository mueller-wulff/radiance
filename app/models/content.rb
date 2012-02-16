class Content < ActiveRecord::Base
  acts_as_paranoid
    
  belongs_to :page
  belongs_to :element, :polymorphic => true
  accepts_nested_attributes_for :element
  acts_as_paranoid :dependent_recovery_window => 1.minute
  
  validate :check_total_weight, :on => :update
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
  
  def check_total_weight
    total_weight = self.weight
    @page = self.page
    page.contents.reject {|c| c == self}.each {|r| total_weight += r.weight.to_f}
    errors.add(:weight, "total weight is over 100%") if total_weight > 100  
  end
    
end
