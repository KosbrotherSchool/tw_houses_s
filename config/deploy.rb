require 'bundler/capistrano'
# require 'hoptoad_notifier/capistrano'

set :application, "tw_houses"
set :rails_env, "production"
set :default_shell, '/bin/bash -l'

set :branch, "master"
set :repository,  "https://github.com/KosbrotherSchool/tw_houses_s.git"
set :scm, "git"
set :user, "apps" # 一個伺服器上的帳戶用來放你的應用程式，不需要有sudo權限，但是需要有權限可以讀取Git repository拿到原始碼

set :deploy_to, "/home/apps/tw_houses"
# set :deploy_via, :remote_cache
set :use_sudo, false

role :web, "106.187.39.88"
role :app, "106.187.39.88"
role :db,  "106.187.39.88", :primary => true

namespace :deploy do

  task :copy_config_files, :roles => [:app] do
    db_config = "#{shared_path}/config/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
  end
  
  task :update_symlink do
    run "ln -s {shared_path}/public/system {current_path}/public/system"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before "deploy:assets:precompile", "deploy:copy_config_files" # 如果將database.yml放在shared下，請打開
after "deploy:update_code", "deploy:copy_config_files" # 如果將database.yml放在shared下，請打開
# after "deploy:finalize_update", "deploy:update_symlink" # 如果有實作使用者上傳檔案到public/system，請打開