class CreateStitchUnits < ActiveRecord::Migration
  def self.up
    create_table :stitch_units do |t|
      t.integer :stitch_module_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :stitch_units
  end
end
