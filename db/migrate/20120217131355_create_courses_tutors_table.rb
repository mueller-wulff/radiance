class CreateCoursesTutorsTable < ActiveRecord::Migration
  def self.up
    create_table :courses_tutors, :id => false do |t|
      t.references :course, :null => false
      t.references :tutor, :null => false
    end
    add_index :courses_tutors, [:course_id, :tutor_id]
    add_index :courses_tutors, [:tutor_id, :course_id]
  end

  def self.down
    drop_table :courses_tutors
  end
end
