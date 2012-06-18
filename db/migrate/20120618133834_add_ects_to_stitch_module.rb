class AddEctsToStitchModule < ActiveRecord::Migration
  def change
    add_column :stitch_modules, :ects, :integer, :default  => 0
  end
end
