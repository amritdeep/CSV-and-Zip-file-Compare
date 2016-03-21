# config/puma.rb
#puma configuration template setup for cap deploy
# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 6

# app_dir = File.expand_path("../..", __FILE__)
# shared_dir = "#{app_dir}/shared"
home_dir = '/home/keystone'
app_dir = "#{home_dir}/current"
shared_dir = "#{home_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "staging" || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/tmp/pids/puma.pid"
state_path "#{shared_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
