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
      elsif current_user.role.class == Tutor
        target_link = tutor_stitch_unit_page_path(target_page.stitch_unit,target_page)
      elsif current_user.role.class == Student
        target_link = student_stitch_unit_page_path(target_page.stitch_unit,target_page)
      end
      html.gsub!(link, target_link)
    end

    @biblio_links = html.scan(/intern:\/\/biblio/)
    @biblio_links.each do |link|
      target_page = @page.stitch_module.last_page
      if current_user.role.class == Developer        
        if controller.action_name == 'edit'
          target_link = edit_developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        else
          target_link = developer_stitch_unit_page_path(target_page.stitch_unit,target_page)
        end
      elsif current_user.role.class == Tutor
        target_link = tutor_stitch_unit_page_path(target_page.stitch_unit,target_page)
      elsif current_user.role.class == Student
        target_link = student_stitch_unit_page_path(target_page.stitch_unit,target_page)
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
  
  def show_deadline_course(course, student)
    deadline_group = student.groups.map {|g| g if g.course_id == course.id}
    deadline_id = Deadline.where(:deadlinable_id => deadline_group)
    unless deadline_id.empty?
      deadline = Deadline.find(deadline_id)
      return deadline.due_date.strftime('%d.%m.%Y - %H:%M')
    end
  end
  
  def show_deadline_page(page, student)
    unless page.deadlines.empty?
      deadline_group = student.groups.map {|g| g if g.course_id == page.course.id}
      deadline_id = Deadline.where(:group_id => deadline_group[0])
      unless deadline_id.empty?
        deadline = Deadline.find(deadline_id)
        return deadline.due_date.strftime('%d.%m.%Y - %H:%M')
      end
    else
      show_deadline_course(page.course, student)
    end
  end
  
  def find_answer(content)
    element = content.element
    if content.element_type == "Question"
      if element.answers.empty?
        new_student_content_element_answer_path(content, element)
      else        
        a = Answer.where(:student_id => current_user.role.id, :question_id => element.id)
        answer = Answer.find(a)
        edit_student_content_element_answer_path(content, element, answer)
      end
    end
  end
  
end
