class RichText < Element
  set_table_name :rich_texts
  before_create :fill_with_default_text
  
  def fill_with_default_text
    self.txt ||= "<h1>New Rich Text Element</h1><p>Just click to edit</p>"
  end
end
