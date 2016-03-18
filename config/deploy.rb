# config valid only for current version of Capistrano
lock '3.4.0'

# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'


set :application, 'keystone'
set :repo_url, 'git@git.cratebind.com:cratebind/keystone.git'
set :deploy_to, '/home/keystone'
set :rvm_type, :user 
set :bundle_binstubs, -> { '/home/keystone/shared/bin' }
set :pty, true #to run sudo commands
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/local_env.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'bin', 'tmp/keystone')

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

namespace :deploy do
    desc 'Restart the puma server'
    task :restart_puma do
        on roles(:app) do
            within current_path do
                #rescue in case it's not currently running like on initial deploy
                execute( :sudo,  "stop puma app=#{current_path}" ) rescue true
                execute :sudo,  "start puma app=#{current_path}"
                execute :sudo,  "service nginx restart"
            end
        end
    end
    after :published, :restart_puma
end


end
