source 'https://rubygems.org'

ruby '2.1.2'

gem 'hydrogen', :github => 'radiumsoftware/hydrogen'
gem 'iridium', :github => 'radiumsoftware/iridium'
gem 'iridium-ember', :github => 'radiumsoftware/iridium-ember'
gem 'thor', :github => 'wycats/thor'
gem 'rake-pipeline', :github => 'livingsocial/rake-pipeline'
gem 'barber'

gem 'thin'
gem 'puma'
# gem 'therubyracer'

group :development do
  gem 'dnote'
  gem 'guard'

  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
end

group :production do
  gem 'unicorn'
end

group :test do
  gem 'ruby-prof'
  gem 'rack-test'
end
