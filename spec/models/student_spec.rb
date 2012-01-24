require 'spec_helper'

describe Student do
  before(:each) do
    course = Course.create :title => "Stitch Test", :short_title => "STITCH",
      :language => "german", :description => "really cool stuff"
    tutor = Tutor.create(:profile_attributes => {:login => "tutor", :name => "Paul", :email => "bla@bla.de",
                                                 :lastname => "Mueller"})

    @group = Group.create(:title => "Testgroup", :course => course, :tutor => tutor)
  end

  it "shouldn't be destroyed if active" do
    @student = Student.new(:profile_attributes => {:login => "student", :name => "Paul", :lastname => "Mueller", :email => "ding@dong.de"} )
    @student.groups << @group
    @student.save.should be_true
    @student.activate
    @student.destroy.should be_false
  end

  it "should have at least one group" do
    @student = Student.new(:profile_attributes => {:login => "student", :name => "Paul", :lastname => "Mueller", :email => "ding@dong.de"} )
    @student.save.should be_false
  end

  it "should have a profile" do
    @student = Student.new    
    @student.groups << @group
    @student.save.should be_false
  end

  it "should not require name on create" do
    @student = Student.new(:profile_attributes => {:login => "student", :email => "ding@dong.de"} )
    @student.groups << @group
    @student.save.should be_true
  end
end
