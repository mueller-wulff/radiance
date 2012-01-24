class Slideshare < Element
  set_table_name :slideshares
  
  before_create :fill_with_default_text
  
  def fill_with_default_text
    self.slide_link ||= '<div style="width:510px" id="__ss_358803"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/diannekrause/how-to-embed-slideshare-into-wikispaces-358803" title="How To Embed Slideshare Into Wikispaces">How To Embed Slideshare Into Wikispaces</a></strong> <object id="__sse358803" width="510" height="426"> <param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=how-to-embed-slideshare-into-wikispaces-1208453575458232-8&rel=0&stripped_title=how-to-embed-slideshare-into-wikispaces-358803&userName=diannekrause" /> <param name="allowFullScreen" value="true"/> <param name="allowScriptAccess" value="always"/> <embed name="__sse358803" src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=how-to-embed-slideshare-into-wikispaces-1208453575458232-8&rel=0&stripped_title=how-to-embed-slideshare-into-wikispaces-358803&userName=diannekrause" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="510" height="426"></embed> </object> <div style="padding:5px 0 12px"> View more <a href="http://www.slideshare.net/">presentations</a> from <a href="http://www.slideshare.net/diannekrause">diannekrause</a> </div> </div>'
  end
  
  def iframe_url
    return self.slide_link.scan(/value="(http:\/\/\S*)/).first.first.gsub("\"","") if self.slide_link.scan(/value="(http:\/\/\S*)/) && self.slide_link.scan(/value="(http:\/\/\S*)/).first
    return self.slide_link.scan(/iframe src="(http:\/\/\S*)/).first.first.gsub("\"","") if self.slide_link.scan(/iframe src="(http:\/\/\S*)/) && self.slide_link.scan(/iframe src="(http:\/\/\S*)/).first
    return ""
  end
end