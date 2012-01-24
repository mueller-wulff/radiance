class Youtube < Element
  set_table_name :youtubes
  
  before_create :fill_with_default_text
  
  def fill_with_default_text
    self.video_id ||= '<object style="height: 390px; width: 640px"><param name="movie" value="http://www.youtube.com/v/XZ5TajZYW6Y?version=3"><param name="allowFullScreen" value="true"><param name="allowScriptAccess" value="always"><embed src="http://www.youtube.com/v/XZ5TajZYW6Y?version=3" type="application/x-shockwave-flash" allowfullscreen="true" allowScriptAccess="always" width="640" height="390"></object>'
  end
  
  def iframe_url
   if self.video_id.length < 30
     self.video_id = "http://www.youtube.com/embed/"+self.video_id
   end
   
   self.video_id.scan(/(http:\/\/[^"]*)/).first.first
  
  end
end
