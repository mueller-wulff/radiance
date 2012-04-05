class CreateDefaultAssesments < ActiveRecord::Migration
  def change
    create_table :default_assesments do |t|
      t.integer :mark
      t.string :name
      t.integer :lower_treshold
      t.integer :upper_treshold
      t.integer :course_id
      t.integer :tutor_id

      t.timestamps
    end
  end
end
