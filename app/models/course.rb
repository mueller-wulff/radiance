class Course < ActiveRecord::Base
  has_many :stitch_modules, :order => "position"
  has_many :grades, :as => :gradable
  has_many :groups
  has_many :developers
  has_and_belongs_to_many :tutors
  has_many :default_assesments
  
  belongs_to :parent_course, 
    :class_name => "Course",
    :foreign_key => 'parent_id'
  
  validates :title, :presence => true, :uniqueness => true, :length => {:minimum => 3}
  validates :short_title, :presence => true, :length => {:minimum => 3}, :uniqueness => true 
  validates :language, :presence => true
  
  before_destroy :deletable?
  before_save :enforce_logic
  
  def enforce_logic
    #only with modules which are all completed can a course be marked as complete
    if self.published && !self.publishable?
      errors.add :complete,"cannot complete course with incomplete modules"
      return false
    end
    
    #only a course with no students can be marked as deprecated
    if self.deprecated && !self.deprecatable?
      errors.add :deprecated, "cannot deprecate course with active students"
      return false
    end
    
    return true
  end  
  
  def publishable?
    if self.stitch_modules != [] && self.stitch_modules.map{|m|m.complete}.uniq == [true]
      return true
    else
      return false
    end
  end
  
  def deprecatable?
    if self.groups.map{|g| g.active}.uniq == [false] && self.published
      return true
    else
      return false
    end
  end
  
  def deletable?
    #can only be deleted if truly empty
    if self.stitch_modules == [] && self.groups == []
      return true
    else
      errors.add(:base, "cannot delete a non empty course!")
      return false
    end
  end
  
  def order_modules( order )
    transaction do
      order.each_with_index do |module_id,index|
        sm = self.stitch_modules.find(module_id)
        sm.update_attribute(:position, index+1)
      end
    end
  end
  
  def students(tutor)
    return self.groups.map{|g| g.students.where(:activated => true) if g.tutor == tutor }.flatten.compact
  end
  
  def all_assignment_pages
    self.stitch_modules.map {|sm| sm.pages.where(:assignment => true) }.flatten
  end
  
end
