class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :txt
      t.integer :student_id
      t.integer :question_id
      t.boolean :locked
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
