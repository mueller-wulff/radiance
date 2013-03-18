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
      else
        students = Group.find(deadline.group_id).all_students
        page = Page.find(deadline.deadlinable_id)
        students.map {|student| Answer.lock_answers(student, page)}
      end
    end
    
    def submit_group_essay(deadline)
      if deadline.deadlinable_type == "Group"
        group = Group.find(deadline.deadlinable_id)
        pages = group.course.all_assignment_pages
        pages.map {|page| GroupEssayAnswer.submit_group_essay(group, page)}
      else
        group = Group.find(deadline.group_id)
        page = Page.find(deadline.deadlinable_id)
        GroupEssayAnswer.submit_group_essay(group, page)
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
        child_groups.map {|g| g.update_attribute(:active, false) }
      end
    end
    
    Deadline.all.each do |d|
      if (d.due_date - 3.days).today?
        send_information_mail(d)
      elsif (d.due_date + 1.day).today? || d.expired?
        lock_answers(d)
        submit_group_essay(d)
        send_info_to_tutor(d)
        set_group_inactive(d)
      end
    end    
  end
end