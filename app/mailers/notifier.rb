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
    subject       "Welcome to STITCHed"  
    recipients    student.profile.email  
    sent_on       Time.now  
    from          "accounts@stitched.com"
    @student  = student
    @group    = group
  end  
  
end
