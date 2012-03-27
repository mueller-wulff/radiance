class Notifier < ActionMailer::Base
  
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    recipients    user.email  
    sent_on       Time.now  
    from          "accounts@stitched.com"
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end 
  
  def send_password(user)
    subject       "Welcome to STITCHed"  
    recipients    user.email  
    sent_on       Time.now  
    from          "accounts@stitched.com"
    @user  = user 
  end
  
  def new_group(student, group)
    subject       "New Group"  
    recipients    student.profile.email  
    sent_on       Time.now  
    from          "accounts@stitched.com"
    @student  = student
    @group    = group
  end  
  
  def send_answers(group, student, page)
    subject     "Assignment finished"
    recipients  group.tutor.profile.email
    sent_on     Time.now
    from        "accounts@stitched.com"
    @tutor      = group.tutor
    @student    = student
    @page       = page
    @url        = show_answers_tutor_group_student_page_url(group, student, page)
  end
  
end
