class RenameEditorStitchModuleToDeveloperStitchModule < ActiveRecord::Migration
  def self.up
    rename_table :editors_stitch_modules, :developers_stitch_modules
    rename_column :developers_stitch_modules, :editor_id, :developer_id

  end

  def self.down
    rename_table :developers_stitch_modules, :editors_stitch_modules
    rename_column :editors_stitch_modules, :developer_id, :editor_id
  end
end
