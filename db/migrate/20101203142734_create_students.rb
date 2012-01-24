class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.boolean :activated, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
