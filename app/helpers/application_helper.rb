module ApplicationHelper
  def filter_local_links(html)

    #replace local page links
    @page_links = html.scan(/intern:\/\/page\/\d*/)
    @page_links.each do |link|
      target_page = Page.find_by_id(link.scan(/intern:\/\/page\/(\d*)/))
      if current_user.role.class == Developer
        if controller.action_name == 'edit'
          target_link = edit_developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        else
          target_link = developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        end
      else
        #Student and Tutor stuff
      end
      html.gsub!(link, target_link)
    end

    @biblio_links = html.scan(/intern:\/\/biblio/)
    @biblio_links.each do |link|
      if current_user.role.class == Developer
        target_page = @page.stitch_module.last_page
        if controller.action_name == 'edit'
          target_link = edit_developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        else
          target_link = developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        end
      else
        #Student and Tutor stuff
      end
      html.gsub!(link, target_link)
    end
    
    @faq_links = html.scan(/intern:\/\/faq/)
    @faq_links.each do |link|
      target_link = faqs_path
      html.gsub!(link, target_link)      
    end

    html
  end
  
  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.profile.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm"
  end
  
end
