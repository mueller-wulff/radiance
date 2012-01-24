class Developer < Role
  
  has_and_belongs_to_many :stitch_modules
  set_table_name :developers
  
  
  def courses
    #self.stitch_modules.map {|sm| sm.course}.uniq
    Course.all
  end
  
  def editable(stitch_module)
    return true if self.admin
    if self.stitch_modules.include?(stitch_module)
      return true
    else
      return false
    end
  end
end
