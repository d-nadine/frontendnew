set :branch, 'deploy-master'
set :rack_env, 'production'

set :puma_threads, [2, 4]
set :puma_workers, 2

set :api_host, 'http://productiontest.radiumcrm.com:3333'
set :intercom_app_id, 'd5bd1654e902b81ba0f4161ea5b45bb597bfefdf'

server '104.131.122.126', user: 'deployer', roles: %w{app web db sidekiq}
