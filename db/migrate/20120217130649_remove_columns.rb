class RemoveColumns < ActiveRecord::Migration
  def self.up
    remove_column :tutors, :course_id
    remove_column :questions, :answers
  end

  def self.down
    add_column :tutors, :course_id, :integer
    add_column :questions, :answers, :text
  end
end
