require 'spec_helper'

describe RichText do
  let!(:course){Course.create(:title => "asd", :short_title => "asd", :language => "german")}
  let!(:smodule){course.stitch_modules.create(:title => "test", :short_title => "test")}
  let!(:sunit){smodule.stitch_units.create(:title => "test")}
  
  let!(:page){sunit.pages.create(:title => "Seite 1")}
  let!(:content){page.contents.new}
  it "should behave like a content element" do
    content.element = RichText.create(:txt => "Teststring")
    content.save
    content.element.class.should == RichText
  end
end
