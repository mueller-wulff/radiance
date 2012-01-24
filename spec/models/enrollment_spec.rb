require 'spec_helper'

describe Enrollment do
  before(:each) do
    @course = Course.create :title => "Stitch Test", :short_title => "STITCH",
      :language => "german", :description => "really cool stuff"
    @tutor = Tutor.create(:profile_attributes => {:login => "tutor", :name => "Paul", :email => "bla@bla.de",
                                                  :lastname => "Mueller"})
    @group = Group.create(:title => "Testgroup", :course => @course, :tutor => @tutor)
    @student = Student.create(:groups => [@group], :profile_attributes => {:login => "student", :name => "Paul",
                           :lastname => "Mueller", :email => "dasd@adde.de"})
  end

  it "should be uniq" do
    @student.should_not == nil
    @student.groups.should_not == []
    @student.enrollments.size.should == 1
    lambda {@student.groups << group}.should raise_error
  end

  it "should be uniq across courses" do
    second_group =  Group.create(:title => "Testgroup2", :course => @course, :tutor => @tutor)
    lambda {@student.groups << second_group}.should raise_error
  end

  it "should only be destroyable if@student is about to be destroyed" do
    #student.activate
    #group.destroy.should be_false
    @student.destroy.should be_true
    @group.enrollments.should == []
  end

  it "shouldn't be destroyable in any other case" do
    @group.students == []
    @group.save
    @student.groups.should_not == []
    Enrollment.all.should_not == []
  end


  pending "should be set as completed if@student answered all questions of the course" do

  end
end
