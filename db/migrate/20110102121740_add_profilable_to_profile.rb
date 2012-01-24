class AddProfilableToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :role_id, :integer
    add_column :profiles, :role_type, :string
  end

  def self.down
    remove_column :profiles, :role_id
    remove_column :profiles, :role_type
  end
end
