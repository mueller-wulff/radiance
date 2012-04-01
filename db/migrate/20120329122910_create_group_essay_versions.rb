class CreateGroupEssayVersions < ActiveRecord::Migration
  def change
    create_table :group_essay_versions do |t|
      t.text :txt
      t.integer :student_id
      t.integer :group_essay_id
      t.integer :version_nr
      t.boolean :current
      t.boolean :locked
      t.text :comment
      t.integer :score
      t.integer :group_id

      t.timestamps
    end
  end
end
