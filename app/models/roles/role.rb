class Role < ActiveRecord::Base
  self.abstract_class = true 
  
  has_one :profile, :as => :role, :dependent => :destroy
  #after_create :send_password
  accepts_nested_attributes_for :profile
  
  
  def send_password
    self.profile.send_password
  end

end
