class AddMoreFieldsToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :group_id, :integer
    add_column :channels, :closed, :boolean
  end
end
