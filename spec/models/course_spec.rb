require 'spec_helper'

describe Course do
  let(:course) {Course.create :title => "Stitch Test", :short_title => "STITCH", :language => "german", :description => "really cool stuff"}

  it "shouldn't complete with no modules" do
    course.published = true
    course.save.should be_false
  end
  
  it "shouldn't be published with incomplete modules" do
    course.stitch_modules.create(:title => "TestModul", :short_title => "test")
    #course.stitch_modules.count.should == 1
    course.published = true
    course.save.should be_false
  end
  
  it "should be published with completed modules" do
    course.stitch_modules.create(:title => "TestModul", :complete => true, :short_title => "test")
    course.stitch_modules.count.should == 1
    course.published = true
    course.stitch_modules.map{|m|m.complete}.uniq.should be_true
    course.save
    puts course.errors.inspect
    course.save.should be_true
  end
  
  it "shouldn't be destroyed when not empty" do
    course.stitch_modules.create(:title => "TestModul", :short_title => "test")
    course.destroy.should be_false
  end
  
  it "should be destroyable when empty" do
    course.destroy.should be_true 
  end
  
  it "shouldn't be able to be deprecated if any groups are still active" do
    tutor = stub(Tutor, :id => 1)
    course.groups.create(:title => "testgroup", :tutor_id => tutor.id)
    course.groups.count.should == 1
    course.deprecated = true
    course.save.should be_false
  end
  
  it "should be able to deprecate if all groups are inactive" do
    tutor = stub(Tutor, :id => 1)
    course.stitch_modules.create(:title => "TestModul", :complete => true, :short_title => "test")
    course.published = true
    course.save.should be_true
    course.groups.create(:title => "testgroup", :tutor_id => tutor.id, :active => false)
    course.groups.count.should == 1
    course.deprecated = true
    course.save.should be_true
  end
  
  pending "should be able to be copied if marked complete" do
    course.copy.should be_false
    course.stitch_modules.create(:title => "TestModul", :complete => true, :short_title => "test")
    course.copy.should be_true
  end
end
