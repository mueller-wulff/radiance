class Notifier < ActionMailer::Base
  default :from => "accounts@stitched.com"
  
  def password_reset_instructions(user)  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
    mail(:to => user.email, :subject => I18n.t(:pw_reset_instruction, :scope => :mailer) )
  end 
  
  def send_password(user)
    @user  = user 
    mail(:to => user.email, :subject => I18n.t(:welcome, :scope => :mailer) )
  end
  
  def new_group(student, group)
    @student  = student
    @group    = group    
    mail(:to => student.profile.email, :subject => I18n.t(:new_group, :scope => :mailer))
  end  
  
  def send_answers(group, student, page)
    @tutor      = group.tutor
    @student    = student
    @page       = page
    @url        = show_answers_tutor_group_student_page_url(group, student, page)
    mail(:to => group.tutor.profile.email, :subject => I18n.t(:assignment_finished, :scope => :mailer))
  end
  
  def send_deadline_reached(students, deadline, type)
    @deadline = deadline
    @type = type
    mail(:to => students.map{|s| s.profile.email}, :subject => I18n.t(:deadline_reached, :scope => :mailer))
  end
  
end
