namespace :deadline do
  task :check_due_date => :environment do
    
    def send_information_mail(deadline)
            
    end
    
    Deadline.all.each do |d|
      now = Time.now
      if d.due_date - now < 3.days
        send_information_mail(d)
      end
    end    
  end
end