# These should be set in production.rb
# server '164.92.80.13',  port: 22, roles: [:web, :app, :db], primary: true

server '143.198.247.64',  port: 22, user: 'deploy', roles: %w[db web app], primary: true
set :repo_url,        'git@github.com:lreardon/ratemyskipper.git'
set :branch,          :main
set :application,     'ratemyskipper'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_ed25519.pub) }
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

# set :puma_user, fetch(:user)
# set :puma_role, :web
# set :puma_service_unit_env_files, []
# set :puma_service_unit_env_vars, []

## Defaults:
# set :scm,           :git
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w[config/credentials/production.key]

# set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]

set :default_env, { 'RAILS_ENV' => 'production' }

namespace :puma do
	desc 'Create Directories for Puma Pids and Socket'
	task :make_dirs do
		on roles(:app) do
			execute "mkdir #{shared_path}/tmp/sockets -p"
			execute "mkdir #{shared_path}/tmp/pids -p"
		end
	end

	before :start, :make_dirs
end

namespace :deploy do
	desc 'Make sure local git is in sync with remote.'
	task :check_revision do
		on roles(:app) do
			unless `git rev-parse HEAD` == `git rev-parse origin/main`
				puts 'WARNING: HEAD is not the same as origin/main'
				puts 'Run `git push` to sync changes.'
				exit
			end
		end
	end

	desc 'Initial Deploy'
	task :initial do
		on roles(:app) do
			before 'deploy:restart', 'puma:start'
			invoke 'deploy'
		end
	end

	desc 'Restart sidekiq to use the newly deployed version.'
	task :restart_sidekiq do
		on roles(:app) do
			execute 'sudo systemctl restart sidekiq'
		end
	end

	before :starting,     :check_revision
	after  :finishing,    :restart_sidekiq
	after  :finishing,    :compile_assets
	after  :finishing,    :cleanup
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
