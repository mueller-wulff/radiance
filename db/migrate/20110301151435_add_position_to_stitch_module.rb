class AddPositionToStitchModule < ActiveRecord::Migration
  def self.up
    add_column :stitch_modules, :position, :integer
  end

  def self.down
    remove_column :stitch_modules, :position
  end
end
