# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Course.create(
  :title => 'STITCH',
  :short_title => 'ST',
  :description => 'Some description.',
  :parent_id => 1)

StitchModule.create(
  :title => 'First Module',
  :short_title => 'M1',
  :description => 'Some description to Module 1',
  :course_id => 1)


StitchModule.create(
  :title => 'Second Module',
  :short_title => 'M2',
  :description => 'Some description to Module 2',
  :course_id => 1)

StitchModule.create(
  :title => 'Third Module',
  :short_title => 'M3',
  :description => 'Some description to Module 3',
  :course_id => 1)

Page.create(
  :title => 'Page01',
  :stitch_module_id => '1',
  :content_type => 'RichTextUnit')

Page.create(
  :title => 'Unit1', 
  :markup_content => '<h1>Header</h1>',
  :stitch_module_id => '1')

Profile.create(
  :email => "admin@rapidrabbit.de",
  :password => "geheim",
  :password_confirmation => "geheim",
  :name => "admin",  
  :lastname => "istrator",
  :profilable => Teacher.create(:admin => true)
)