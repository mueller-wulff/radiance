class RenameEditorToDeveloper < ActiveRecord::Migration
  def self.up
    rename_table :editors, :developers
  end

  def self.down
    rename_table :developers, :editors
  end
end
