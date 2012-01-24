rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes (rails_env == 'production' ? 2 : 1)

preload_app false

timeout 30

listen '/var/www/stitch/shared/unicorn.sock', :backlog => 2048
