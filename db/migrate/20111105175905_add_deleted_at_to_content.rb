class AddDeletedAtToContent < ActiveRecord::Migration
  def change
    add_column :contents, :deleted_at, :datetime
  end
end
