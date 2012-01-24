class AddProfilePasswordResetFieldToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :perishable_token, :string, :default => "", :null => false 
    
    add_index :profiles, :perishable_token  
    add_index :profiles, :email
  end

  def self.down
    remove_column :profiles, :perishable_token
  end
end
