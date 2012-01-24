class CreateStitchModules < ActiveRecord::Migration
  def self.up
    create_table :stitch_modules do |t|
      t.string :title
      t.text :description
      t.integer :course_id
      t.boolean :complete, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :stitch_modules
  end
end
