lock '3.4.0'

set :application, 'radium-front'
set :repo_url, 'git@github.com:radiumsoftware/frontend.git'

set :deploy_to, '/var/www/radium-front/'

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 5
set :ssh_options, { forward_agent: true }

set :rvm_ruby_version, '2.2.4@radium-frontend'

set :sidekiq_config, -> {File.join(shared_path, 'config', 'sidekiq.yml')}
set :sidekiq_processes, 1
set :sidekiq_log, -> {File.join(shared_path, 'log', 'sidekiq.log')}
set :sidekiq_role, :sidekiq

set :puma_preload_app, true
set :puma_init_active_record, true
