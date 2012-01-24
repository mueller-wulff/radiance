class CreateProfileSessions < ActiveRecord::Migration
  def self.up
    create_table :profile_sessions do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_sessions
  end
end
