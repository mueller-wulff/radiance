class CreateGroupEssays < ActiveRecord::Migration
  def change
    create_table :group_essays do |t|
      t.integer :max_length
      t.text :txt

      t.timestamps
    end
  end
end
