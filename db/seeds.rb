# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

@admin = Developer.new(:admin => true)
@admin.build_profile(:name => "Admin", :lastname => "Istrator", :email => "sarah@rapidrabbit.de", :login => "admin")
@admin.save