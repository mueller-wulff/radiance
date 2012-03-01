class AddGroupIdToDeadline < ActiveRecord::Migration
  def change
    add_column :deadlines, :group_id, :integer
  end
end
