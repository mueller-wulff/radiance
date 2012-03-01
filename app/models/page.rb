class Page < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to :stitch_unit
  acts_as_paranoid :dependent_recovery_window => 1.minute
  
  validates :stitch_unit_id, :presence => true
  has_one :stitch_module, :through => :stitch_unit
  has_many :contents, :dependent => :destroy, :order => "position" 
  has_many :deadlines, :as => :deadlinable
  
  accepts_nested_attributes_for :deadlines

  before_create :fill_with_default_content
    
  def fill_with_default_content
    self.title ||= "new Page" 
    unless self.position
      if self.stitch_unit.pages == []
        self.position = 1
      else
        self.position = self.stitch_unit.pages.last.position + 1
      end
    end
  end
  
  def previous_page
    page = self
    sunit = page.stitch_unit
    smodule = sunit.stitch_module
    if sunit.pages.first == page
      if sunit == smodule.stitch_units.order(:position).first
        return false
      else
        prev_unit = smodule.stitch_units.where("position < ?", sunit.position).first
        if prev_unit.pages != []
          prev_unit.pages.last 
        else
          return false
        end
      end
    else
      sunit.pages.where("position < ?", page.position).last
    end
  end

  def next_page
    page = self
    sunit = page.stitch_unit
    smodule = sunit.stitch_module
    if sunit.pages.last == page
      if sunit == smodule.stitch_units.last
        return false
      else
        next_unit =  smodule.stitch_units.where("position > ?", sunit.position).first
        if next_unit.pages != []
          next_unit.pages.first 
        else
          return false
        end
      end
    else
      sunit.pages.where("position > ?", page.position).first
    end
  end
  
  
  def copy_to_unit(new_unit)
    transaction do
      @copy = self.dup
      @copy.save!
      @copy.update_attribute(:stitch_unit, new_unit)
      
      #trigger content copy
      self.contents.each do |content|
        content.copy_to_page(@copy)
      end
      
    end
    return @copy || false
  end
  
  def move_to_unit(new_unit)
    self.update_attribute(:stitch_unit, new_unit)
  end
    
  
  def order_contents( order )
    transaction do
      order.each_with_index do |content_id,index|
        content = self.contents.find(content_id)
        content.update_attribute(:position, index + 1)
      end
    end
  end
  
  def create_page_deadline(deadlines, page)
    new_deadlines = []
    deadlines.keys.each {|key| new_deadlines << deadlines[key] if deadlines[key]["new_deadline"] == "1"}
    new_deadlines.each do |d|
      tmp_date = DateTime.new( d["due_date(1i)"].to_i, d["due_date(2i)"].to_i, d["due_date(3i)"].to_i, d["due_date(4i)"].to_i, d["due_date(5i)"].to_i )
      @deadline = Deadline.new
      @deadline.due_date = tmp_date
      @deadline.group_id = d["group_id"]
      @deadline.deadlinable = page
      @deadline.save
    end
  end
  
  def course
    self.stitch_unit.course
  end
    
end

 