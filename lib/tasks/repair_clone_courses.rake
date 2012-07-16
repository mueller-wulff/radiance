namespace :course do
  task :repair_clone_courses, [:course_id] => :environment do |t, args|
    return if args.course_id.nil?
    course = Course.find(args.course_id)
    c_clones = Course.where(:parent_id => course.id)
    puts "clones: #{c_clones.size}"
    stitch_modules = []
    if course.id == 1
      stitch_modules << StitchModule.find(4)
      stitch_modules << StitchModule.find(7)
      stitch_modules << StitchModule.find(5)
      stitch_modules << StitchModule.find(66)
    elsif course.id == 3
      stitch_modules << StitchModule.find(17)
      stitch_modules << StitchModule.find(18)
      stitch_modules << StitchModule.find(19)
      stitch_modules << StitchModule.find(65)
    end
    c_clones.delete_if {|c| c.id == 18 if course.id == 1}
    c_clones.each do |clone|
      stitch_modules.each do |sm|
        clone_module = clone.stitch_modules.where(:title => sm.title).first
        sm.stitch_units.each_with_index do |su, j|
          clone_unit = clone_module.stitch_units[j]
          clone_unit.pages.delete_all
          su.pages.each do |page|
            clone_page = page.dup :include => :contents
            clone_page.stitch_unit = clone_unit
            clone_page.save!
            page.contents.each_with_index do |c, k|
              clone_content = clone_page.contents[k]
              clone_element = c.element.dup
              clone_element.content = clone_content
              clone_element.save!
            end # content
          end # page
        end # stitch_unit
      end # stitch_modules
    end # clone_course

    # extra code for german ba course cause of translation
    if course.id == 1
      stitch_modules.pop
      clone = Course.find(18)
      clone_modules = []
      clone_modules << StitchModule.find(134)
      clone_modules << StitchModule.find(135)
      clone_modules << StitchModule.find(136)

      stitch_modules.each_with_index do |sm, i|
        clone_module = clone.stitch_modules.where(:id => clone_modules[i].id).first
        sm.stitch_units.each_with_index do |su, j|
          clone_unit = clone_module.stitch_units[j]
          su.pages.each do |page|
            clone_page = page.dup :include => :contents
            clone_page.stitch_unit = clone_unit
            clone_page.save
            page.contents.each_with_index do |c, k|
              clone_content = clone_page.contents[k]
              clone_element = c.element.dup
              clone_element.content = clone_content
              clone_element.save
            end # content
          end # page
        end # stitch_unit
      end # stitch_module
    end # if course
  end # task
end # namespace
