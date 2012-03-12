class RemoveColumns < ActiveRecord::Migration
  def self.up
    remove_column :tutors, :course_id
  end

  def self.down
    add_column :tutors, :course_id, :integer
  end
end
