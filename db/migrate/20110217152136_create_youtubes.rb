class CreateYoutubes < ActiveRecord::Migration
  def self.up
    create_table :youtubes do |t|
      t.string :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :youtubes
  end
end
