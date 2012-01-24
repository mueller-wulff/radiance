require 'spec_helper'

describe StitchModule do
  let!(:course){Course.create(:title => "asd", :short_title => "asd", :language => "german")}
  let(:smodule){course.stitch_modules.create(:title => "test", :short_title => "test")}
  
  it "should be created" do
    smodule.should_not == nil
  end
  
  it "shouldn't be destroyable if it has pages"
  
end
