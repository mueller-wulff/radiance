rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes (rails_env == 'production' ? 1 : 1)

preload_app false

timeout 30

listen ENV['HOME'] + '/app/shared/sockets/unicorn.sock', :backlog => 2048
