class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :page_id
      t.references :element, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
