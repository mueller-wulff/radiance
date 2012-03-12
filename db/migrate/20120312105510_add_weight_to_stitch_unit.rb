class AddWeightToStitchUnit < ActiveRecord::Migration
  def change
    add_column :stitch_units, :weight, :float
    add_column :answers, :score, :integer
  end
end
