require "bundler/capistrano"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/mysql"
load "config/recipes/nodejs"
#load "config/recipes/rbenv"
load "config/recipes/check"

server "192.168.1.254", :web, :app, :db, primary: true

#set :whenever_command, "bundle exec whenever"
#set :whenever_environment, "production"

#require "whenever/capistrano"
require 'sidekiq/capistrano'

#set :sidekiq_cmd, "#{bundle_cmd} exec sidekiq"
#set :sidekiqctl_cmd, "#{bundle_cmd} exec sidekiqctl"
#set :sidekiq_timeout, 10
#set :sidekiq_role, :app
#set :sidekiq_pid, "#{current_path}/tmp/pids/sidekiq.pid"
#set :sidekiq_processes, 1

set :user, "deployer"
set :application, "smsmanager"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:DigitalTsotsi/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy:create_symlink", "deploy:migrate"
