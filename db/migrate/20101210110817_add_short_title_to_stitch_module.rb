class AddShortTitleToStitchModule < ActiveRecord::Migration
  def self.up
     add_column :stitch_modules, :short_title, :string
  end

  def self.down
    remove_column :stitch_modules, :short_title
  end
end
