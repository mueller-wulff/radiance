class ChangeDataTypeForGradeValue < ActiveRecord::Migration
  def up
    change_table :grades do |t|
      t.change :value, :float
    end
  end

  def down
    change_table :grades do |t|
      t.change :value, :integer
    end
  end
end
