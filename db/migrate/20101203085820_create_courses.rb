class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :title
      t.string :short_title
      t.text :description
      t.integer :parent_id
      t.string :language
      t.boolean :published, :default => false
      t.boolean :deprecated, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
