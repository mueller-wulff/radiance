class Element < ActiveRecord::Base
  self.abstract_class = true 
  has_one :content, :as => :element
end