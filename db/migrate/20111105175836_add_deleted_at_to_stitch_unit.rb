class AddDeletedAtToStitchUnit < ActiveRecord::Migration
  def change
    add_column :stitch_units, :deleted_at, :datetime
  end
end
