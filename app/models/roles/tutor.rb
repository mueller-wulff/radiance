class Tutor < Role
  set_table_name :tutors
  
  has_many :groups
end
