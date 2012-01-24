class CreateDiscussionLinks < ActiveRecord::Migration
  def change
    create_table :discussion_links do |t|
      t.string :title

      t.timestamps
    end
  end
end
