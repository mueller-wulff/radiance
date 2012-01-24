class ChangeYoutube < ActiveRecord::Migration
  def self.up
    change_column :youtubes, :video_id, :text
  end

  def self.down
    change_column :youtubes, :video_id, :string
  end
end
