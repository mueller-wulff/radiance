class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.integer :value
      t.integer :gradable_id
      t.string :gradeable_type
      t.integer :student_id
      t.integer :tutor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :grades
  end
end
