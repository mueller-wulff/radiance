class RenameGradeableTypeToGradableType < ActiveRecord::Migration
  def up
    rename_column :grades, :gradeable_type, :gradable_type
  end

  def down
    rename_column :grades, :gradable_type, :gradeable_type
  end
end
