class Profile < ActiveRecord::Base
 # validates :login, :presence => true, :uniqueness => true, :length => {:minimum => 3, :maximum => 8}
  belongs_to :role, :polymorphic => true
  
  validates :name, :presence => true, :unless => :inactive_student
  validates :lastname, :presence => true, :unless => :inactive_student
  validates :role_type, :presence => true
  validates :email,
    :presence => true,
    :uniqueness => true,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
    :on => :create
  #validates :role_id, :presence => true
  validates_associated :role
   
  before_validation :generate_password, :on => :create
 
  
  acts_as_authentic do |c|
    c.maintain_sessions = false
    #for more options check the AuthLogic documentation
  end
  
  def fullname
    "#{self.name} #{self.lastname}"
  end
  
  def self.find_by_login_or_email(login)
     find_by_login(login) || find_by_email(login)
  end  
  
  def inactive_student
    # if role_type == 'Student' 
    #       student = Student.find(role_id)
    #       return false if student.nil?
    #       return false if student.activated
    #       return true
    #     end
    #     return false
    role_type == 'Student' && role == nil
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions.deliver(self)  
  end  
  
  def generate_password
    self.password = ActiveSupport::SecureRandom.hex(4)
    self.password_confirmation = self.password
    self.tmp_passwd = self.password
  end
  
  def send_password
    if Notifier.send_password(self).deliver
      self.update_attribute(:tmp_passwd, nil)
    end
  end

end
