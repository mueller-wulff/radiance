# =============================
# = Allgemeine Einstellungen =
# =============================
set :application, "stitch"
set :domain, "main.rapidrabbit.de"
# für ein lokales Repo:
# set :repository, "/pfad/zum/repo-ordner"
set :repository, "sftp://phm@main.rapidrabbit.de/srv/bzr/rails/radiance/rails3.1"
set :deploy_to, "/var/www/#{application}"
set :scm, :bzr
set :deploy_via, :copy # default ist :checkout
set :user, "stitch" # default ist der aktuelle User
set :use_sudo, false # Verwende kein sudo
default_run_options[:pty] = true
# =========
# = Roles =
# =========
role :app, "#{domain}"
role :web, "#{domain}"
role :db, "#{domain}", :primary => true

#passenger specific tasks
namespace :passenger do

  task :restart do
    #invoke_command "touch #{current_path}/tmp/restart.txt"
    invoke_command "unicorn.pl -u #{application} -a restart"
  end

end

#Override stuff
namespace :deploy do

  task :restart do
    passenger.restart
  end

  task :start do
    #NOP
  end

  task :stop do
    #NOP
  end
end