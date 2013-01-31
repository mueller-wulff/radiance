# =============================
# = Allgemeine Einstellungen =
# =============================
set :application, "stitch"
set :domain, "main.vm.over9000.org"
# für ein lokales Repo:
# set :repository, "/pfad/zum/repo-ordner"
set :repository, "git://github.com/mueller-wulff/radiance.git"
set :deploy_to, "/home/stitchapp/app"
set :scm, :git
set :deploy_via, :copy # default ist :checkout
set :user, "stitchapp" # default ist der aktuelle User
set :use_sudo, false # Verwende kein sudo
default_run_options[:pty] = true
# =========
# = Roles =
# =========
role :app, "#{domain}"
role :web, "#{domain}"
role :db, "#{domain}", :primary => true

#passenger specific tasks
namespace :unicorn do

  task :restart do
    #invoke_command "touch #{current_path}/tmp/restart.txt"
    invoke_command "uc.pl stop"
    invoke_command "uc.pl start -c /home/#{user}/app/current/unicorn.rb"
  end

end

#Override stuff
namespace :deploy do

  task :restart do
    unicorn.restart
  end

  task :start do
    #NOP
  end

  task :stop do
    #NOP
  end
end

namespace :db do  
  task :db_config, :except => { :no_release => true }, :role => :app do  
    run "cp -f /home/stitchapp/app/database.yml #{release_path}/config/database.yml"  
  end  
end  

namespace :clean_up do
  task :remove_releases, :role => :app do
    run "for dir in $(ls #{deploy_to}/releases|sort -nr|tail -n +10); do rm -rf #{deploy_to}/releases/$dir; done"
  end
end
  
after "deploy:finalize_update", "db:db_config", "clean_up:remove_releases"