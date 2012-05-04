class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :channel_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
