class CreateRichTexts < ActiveRecord::Migration
  def self.up
    create_table :rich_texts do |t|
      t.text :txt
      t.timestamps
    end
  end

  def self.down
    drop_table :rich_texts
  end
end
