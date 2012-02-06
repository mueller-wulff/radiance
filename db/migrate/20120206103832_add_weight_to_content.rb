class AddWeightToContent < ActiveRecord::Migration
  def change
    add_column :contents, :weight, :float
  end
end
