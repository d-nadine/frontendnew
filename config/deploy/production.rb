set :branch, 'deploy-master'
set :rack_env, 'production'

set :puma_threads, [2, 4]
set :puma_workers, 2

server '104.131.122.126', user: 'deployer', roles: %w{app web db sidekiq}
