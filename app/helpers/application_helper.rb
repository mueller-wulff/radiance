module ApplicationHelper
  def errors_for(instance_of_model)
   if instance_of_model.errors.any? 
     content_tag(:div,
      content_tag(:h2, pluralize(instance_of_model.errors.count, "error") + "prohibited this profile from being saved:") +
      content_tag(:ul, instance_of_model.post.errors.full_messages.map do |msg|
        raw(content_tag(:li, msg))
      end.join(''), :id => "error_explanation"))
    end
  end

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

  def show_deadline_course(course, student=nil, group=nil)
    if student
      deadline_group = student.groups.map {|g| g if g.course_id == course.id}.compact.first.meta_group
      deadline = Deadline.where(:deadlinable_id => deadline_group).first
    elsif group
      deadline = Deadline.where(:deadlinable_id => group.id).first
    end
    unless deadline.nil?
      return deadline.due_date.strftime('%d.%m.%Y - %H:%M')
    end
  end

  def show_deadline_page(page, student=nil, group=nil)
    unless page.deadlines.empty?
      if student
        deadline_group = student.groups.map {|g| g if g.course_id == page.course.id}.compact.first.meta_group
        deadline = Deadline.where(:group_id => deadline_group, :deadlinable_id => page.id).first
      elsif group
        deadline = Deadline.where(:group_id => group.id, :deadlinable_id => page.id).first
      end
      unless deadline.nil?
        return deadline.due_date.strftime('%d.%m.%Y - %H:%M')
      end
    end
    show_deadline_course(page.course, student, group)
  end

  def find_answer(content, student)
    element = content.element
    if content.element_type == "Question"
      if element.answers.where(:student_id => student.id).empty?
        new_student_content_element_answer_path(content, element)
      else
        answer = Answer.where(:student_id => current_user.role.id, :question_id => element.id).first
        edit_student_content_element_answer_path(content, element, answer)
      end
    elsif content.element_type == "GroupEssay"
      group = student.find_tutor_of_course(content.page.course)
      if element.group_essay_answers.where(:group_id => group.id).empty?
        new_student_content_element_group_essay_answer_path(content, element)
      else
        answer = GroupEssayAnswer.where(:group_id => group.id, :group_essay_id => element.id).first
        edit_student_content_element_group_essay_answer_path(content, element, answer)
      end
    end
  end

  def show_answer(element, student)
    if element.content.element_type == "Question"
      unless element.answers.where(:student_id => student.id).empty?
        answer = Answer.where(:student_id => student.id, :question_id => element.id).first
        return answer
      end
    elsif element.content.element_type == "GroupEssay"
      unless element.group_essay_answers.empty?
        group = student.find_tutor_of_course(element.content.page.course)
        group_answer = GroupEssayAnswer.where(:group_id => group.id, :group_essay_id => element.id).first
        return group_answer
      end
    end
  end

  def show_whodunnit(group_answer)
    version = group_answer.versions.last
    user = Profile.find(version.whodunnit)
    return user.login
  end

  def show_score(element, user)
    unless element.question_scores.empty?
      score = QuestionScore.where(:tutor_id => user.id, :scoreable_type => element.content.element_type, :scoreable_id => element.id).first
      return score.value if score
    end
  end

  def find_question_score(content, student=nil)
    element = content.element
    if content.element_type == "Question" || content.element_type == "GroupEssay"
      if student && student.give_answer?(student, element) && content.element_type == "Question"
        answer = Answer.where(:student_id => student.id, :question_id => element.id).first
        edit_tutor_content_element_student_answer_path(content, element, student, answer)
      elsif student && content.element_type == "GroupEssay"
        group = student.find_tutor_of_course(element.content.page.course)
        group_answer = GroupEssayAnswer.where(:group_id => group.id, :group_essay_id => element.id).first
        edit_tutor_content_element_student_group_essay_answer_path(content, element, student, group_answer)
      elsif element.question_scores.empty?
        new_tutor_content_element_question_score_path(content, element)
      else
        question_score = QuestionScore.where(:tutor_id => current_user.role.id, :scoreable_type => content.element_type, :scoreable_id => element.id).first
        edit_tutor_content_element_question_score_path(content, element, question_score) if question_score
        new_tutor_content_element_question_score_path(content, element)
      end
    end
  end

  def show_grade(gradable, student, tutor)
    grade = Grade.where(:student_id => student.id, :tutor_id => tutor.id, :gradable_id => gradable.id, :gradable_type => gradable.class.name).first
    return grade.value if grade
    return 0
  end

  def show_national_assessment(value, course)
    default_assessment = DefaultAssesment.where("lower_treshold <= ? AND upper_treshold >= ? AND course_id = ?", value, value, course.id).first
    return default_assessment.name if default_assessment
    return I18n.t(:set_grading_system, :scope => :tutor)
  end

  def find_assignment_page(stitch_unit, group, student, tutor=nil)
    all_assignment_pages = Page.where(:assignment => true)
    unit_assignment_page = all_assignment_pages.where(:stitch_unit_id => stitch_unit.id).first
    if unit_assignment_page.nil?
      return ""
    else
      tutor ? show_answers_tutor_group_student_page_path(group.id, student.id, unit_assignment_page) : student_stitch_unit_page_path(stitch_unit, unit_assignment_page)
    end
  end

  def find_default_assesment(course, tutor)
    def_assesment = DefaultAssesment.where(:course_id => course.id, :tutor_id => tutor.id).first
    if def_assesment.nil?
      new_tutor_course_default_assesment_path(course)
    else
      tutor_course_default_assesment_path(course, def_assesment)
    end
  end

  def find_page_deadline(course, group, page)
    page_deadline = page.deadlines.where(:group_id => group.id).first
    if page_deadline.nil?
      new_tutor_course_deadline_path(course, :group_id => group, :page => page, :group_deadline => group.deadline)
    else
      edit_tutor_course_deadline_path(course, page_deadline)
    end
  end

  def is_assignment_page_locked(page, student)
    questions = page.contents.where(:element_type => "Question")
    questions.each do |q|
      question = Question.find(q.element_id)
      answer = question.answers.where(:student_id => student.id).first
      return true if answer && answer.locked == true
    end
    return false
  end
  
  def show_deadline_title(deadline)
    return deadline.deadlinable.title if deadline.deadlinable_type == "Group"
    return deadline.deadlinable.stitch_unit.title if deadline.deadlinable_type == "Page"
  end
  
  def generate_log(log, tutor, course)
    student = Student.find(log.student_id)
    page = Page.find(log.page_id)
    html = '<tr>'
    html << content_tag('td', "#{student.profile.fullname}")
    html << content_tag('td', "#{page.stitch_module.short_title}")
    html << content_tag('td', (link_to "#{page.stitch_unit.title}", show_answers_tutor_group_student_page_url(student.course_group(course, tutor), student, page ) ) )
    html << '</tr>'
    html.html_safe
  end

  def render_channel(csid)
    channel = Channel.find_or_create_by_channel_string_id(csid)
    render :partial => 'chat/channel', :locals => { :channel => channel }
  end

  # we can talk to the whole group
  # to the group's tutor or student
  def roster_elements()
    roster = current_user.role.groups.map { |r| { type:'group', name:"#{r.title}", channel_id:Channel.find_or_create_by_channel_string_id("all@group-#{r.id}").token }  }
    
    current_user.role.groups.each do |group|
      if current_user.role.class == Student
        course_group = group.meta_group
        roster << { type:'group', name:"#{course_group.title}", channel_id:Channel.find_or_create_by_channel_string_id("all@group-#{course_group.id}").token } if course_group
      end
      roster << { type:"tutor", name:"(T) #{group.tutor.profile.name} #{group.tutor.profile.lastname}", channel_id:build_face2face_channel(group.tutor.profile.id, current_user.id).token } if group.tutor.profile != current_user      
      roster += group.students.map do |s| 
        if s.profile != current_user
          { type:"student", name:"#{s.profile.name} #{s.profile.lastname}", channel_id:build_face2face_channel(s.profile.id, current_user.id).token }
        else
          nil
        end
      end
    end
    roster.compact
  end

  def build_face2face_channel(profile_id1, profile_id2)
    Channel.find_or_create_by_channel_string_id("f2fchat-#{[profile_id1, profile_id2].sort.join('-')}")
  end

end
