class GenerateFirstAdmin < ActiveRecord::Migration
  def self.up    
    @admin = Editor.new(:admin => true)
    @admin.build_profile(:name => "Admin", :lastname => "Istrator", :email => "phm@rapidrabbit.de", :login => "admin")
    @admin.save
  end

  def self.down
  end
end
