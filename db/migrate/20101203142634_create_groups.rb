class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :title
      t.integer :course_id
      t.integer :tutor_id
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
