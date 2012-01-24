class AddMaxLengthToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :max_length, :integer
  end
end
