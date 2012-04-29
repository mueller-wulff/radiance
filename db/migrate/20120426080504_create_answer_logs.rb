class CreateAnswerLogs < ActiveRecord::Migration
  def change
    create_table :answer_logs do |t|
      t.integer :tutor_id
      t.integer :student_id
      t.integer :page_id
      t.integer :course_id

      t.timestamps
    end
  end
end
