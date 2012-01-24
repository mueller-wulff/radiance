require 'spec_helper'

describe Profile do
  
  before(:each) do
    @profile = Profile.new(:login => "test", :email => "ding@dong.de",
      :name => "test", :lastname => "test")
  end
  
  it "should be created after it's role" do    
    @profile.save.should be_false
    user = Developer.new
    user.profile = @profile
    user.save.should be_true
    user.profile.id.should_not == nil
  end
  
  it "should generate and send new password to user" do
    #learn to mock that stuff
  end
  
  it "should forget the tmp password afterwards" do
    @profile.save.should be_false
    user = Developer.new
    user.profile = @profile
    user.profile.tmp_passwd.should_not == nil
    user.save
    user.profile.tmp_passwd.should == nil
  end
  
  # validation tests zum üben
  
  it "should have a name" do
    profile = Profile.new(:login => "test", :email => "ding@dong.de",
      :lastname => "test")   
    profile.save.should be_false
  end
  
  it "should have a lastname" do
    profile = Profile.new(:login => "test", :email => "ding@dong.de",
      :name => "test")
    profile.save.should be_false
  end
  
  it "should have a role" do
    @profile.save.should be_false
    user = Developer.new
    user.profile = @profile
    user.save.should be_true
    user.profile.role_id.should_not == nil
    user.profile.role_type.should_not == nil  
  end
  
end
