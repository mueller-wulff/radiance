class AddPositionToStitchUnit < ActiveRecord::Migration
  def self.up
    add_column :stitch_units, :position, :integer
  end

  def self.down
    remove_column :stitch_units, :position
  end
end
