class Course < ActiveRecord::Base
  has_many :stitch_modules, :order => "position"
  has_many :grades, :as => :gradable
  has_many :groups
  has_many :developers
  has_and_belongs_to_many :tutors
  has_many :default_assesments
  has_many :answer_logs

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
  
  def editable?
    return false if self.published
    return true
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

  def clone_course(params)
    clone_course = self.dup :include => {:stitch_modules => :stitch_units }
    clone_course.parent_id = self.id
    clone_course.title = params[:title]
    clone_course.short_title = params[:short_title]
    clone_course.language = params[:language]
    clone_course.description = params[:description]
    clone_course.published = false
    clone_course.stitch_modules.map {|sm| sm.update_attribute(:complete, false)}
    clone_course.save
    self.stitch_modules.each_with_index do |sm, i|
      clone_module = clone_course.stitch_modules[i]
      sm.stitch_units.each_with_index do |su, j|
        clone_unit = clone_module.stitch_units[j]
        su.pages.each do |page|
          clone_page = page.dup :include => :contents
          clone_page.stitch_unit = clone_unit          
          clone_page.save
          page.contents.each_with_index do |c, k|
            clone_content = clone_page.contents[k]
            clone_element = c.element.dup
            clone_element.content = clone_content
            clone_element.save
          end
        end
      end
    end
  end

end
