class EditorsStitchModulesJoin < ActiveRecord::Migration
  def self.up
    create_table :editors_stitch_modules, :id => false do |t|
      t.integer :stitch_module_id
      t.integer :editor_id
    end
  end

  def self.down
    drop_table :editors_stitch_modules
  end
end
