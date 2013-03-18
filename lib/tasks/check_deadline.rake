namespace :deadline do
  task :check_due_date => :environment do
    
    def send_information_mail(deadline)
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        type = group.course
      else
        group = Group.find(deadline.group_id)
        type = Page.find(deadline.deadlinable_id).stitch_unit
      end
      students = group.all_students
      Notifier.send_deadline_reached(students, deadline, type).deliver
    end
    
    def lock_answers(deadline)
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        pages = group.course.all_assignment_pages
        students = group.all_students
        pages.each do |page|
          students.map {|student| Answer.lock_answers(student, page)}
        end
      elsif !Group.where(:id => deadline.group_id).empty?
        students = Group.find(deadline.group_id).all_students
        page = Page.find(deadline.deadlinable_id)
        students.map {|student| Answer.lock_answers(student, page)}
      end
    end
    
    def submit_group_essay(deadline)
      puts "submit_group_essay"
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        unless group && group.students.empty?
          pages = group.course.all_assignment_pages
          pages.map {|page| GroupEssayAnswer.submit_group_essay(group, page)}
        end
      else
        group = Group.find(deadline.group_id)
        unless group && group.students.empty?
          page = Page.find(deadline.deadlinable_id)
          GroupEssayAnswer.submit_group_essay(group, page)
        end
      end
    end
    
    def send_info_to_tutor(deadline)
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        type = group.course
      else
        group = Group.find(deadline.group_id)
        type = Page.find(deadline.deadlinable_id).stitch_unit
      end
      tutor = group.tutor
      Notifier.send_info_to_tutor(tutor, type, group).deliver
    end
    
    def set_group_inactive(deadline)
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        group.update_attribute(:active, false)
        child_groups = Group.where(:parent_id => group.id)
        child_groups.map {|g| g.update_attribute(:active, false) } if child_groups
      end
    end
    
    Deadline.all.map {|d| d.destroy if d.deadlinable.nil? }
    Deadline.all.map {|d| d.destroy if d.group_id != nil && Group.where(:id => d.group_id).empty? }
    Deadline.all.each do |d|
      if (d.due_date - 3.days).today?
        send_information_mail(d)
      elsif (d.due_date + 1.day).today? || d.expired?
        puts d.id
        lock_answers(d)
        puts "locked answers"
        submit_group_essay(d)
        puts "submitted group essay"
        send_info_to_tutor(d)
        puts "send info to tutor"
        set_group_inactive(d)
        puts "set group inactive"
      end
    end    
  end
end