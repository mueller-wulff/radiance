class CreateSlideshares < ActiveRecord::Migration
  def self.up
    create_table :slideshares do |t|
      t.text :slide_link

      t.timestamps
    end
  end

  def self.down
    drop_table :slideshares
  end
end
