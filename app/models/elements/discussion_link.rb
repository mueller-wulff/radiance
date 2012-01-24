class DiscussionLink < Element
  set_table_name :discussion_links
  before_create :fill_with_default_title

  def fill_with_default_title
    self.title ||= "Please give a title for the Discussion"
  end
end
