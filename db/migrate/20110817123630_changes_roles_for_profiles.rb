class ChangesRolesForProfiles < ActiveRecord::Migration
  def self.up
    Profile.all.each do |profile|
      profile.update_attribute(:role_type, "Developer") if profile.role_type == "Editor"
    end
  end

  def self.down
    Profile.all.each do |profile|
      profile.update_attribute(:role_type, "Editor") if profile.role_type == "Developer"
    end
  end
end
