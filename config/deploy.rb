lock '3.4.0'

set :application, 'radium-front'
set :repo_url, 'git@github.com:radiumsoftware/frontend.git'

set :deploy_to, '/var/www/radium-front/'

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 5
set :ssh_options, { forward_agent: true }

set :rvm_ruby_version, '2.1.2@radium-frontend'

set :puma_preload_app, true
set :puma_init_active_record, true
