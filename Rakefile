require 'bundler/setup'

desc "Loads the app environment"
task :environment do
  require File.expand_path("../config/environment.rb", __FILE__)
end

namespace :assets do
  desc "Compiles the application"
  task :precompile => :environment do
    Iridium.application.compile
  end
end

desc "Compiles the application"
task :compile => "assets:precompile"

namespace :build do
  vendor_path = File.expand_path "../vendor/", __FILE__
  vendor_js_path = File.expand_path "../vendor/javascripts", __FILE__

  desc "Build ember and copy into vendor/javascripts"
  task :ember do
    if File.directory? "#{vendor_path}/ember.js"
      sh "cd #{vendor_path}/ember.js && BUNDLE_GEMFILE=#{vendor_path}/ember.js/Gemfile rake dist"
      sh %Q{cd #{vendor_path}/ember.js && echo "// $(git log -n 1 --format='%h (%ci)')" > #{vendor_js_path}/ember.js}
      sh %Q{cat #{vendor_path}/ember.js/dist/ember.js >> #{vendor_js_path}/ember.js}
    else
      puts "vendor/emberjs does not exist!"
    end
  end

  desc "Build ember-data and copy into vendor/javascripts"
  task :ember_data do
    if File.directory? "#{vendor_path}/data"
      sh "cd #{vendor_path}/data && BUNDLE_GEMFILE=#{vendor_path}/data/Gemfile rake dist"
      sh %Q{cd #{vendor_path}/data && echo "// $(git log -n 1 --format='%h (%ci)')" > #{vendor_js_path}/ember-data.js}
      sh %Q{cat #{vendor_path}/data/dist/ember-data.prod.js >> #{vendor_js_path}/ember-data.js}
    else
      puts "vendor/data does not exist!"
    end
  end
end

desc "Build Ember and Ember Data from local repos"
task :build => ["build:ember", "build:ember_data"]

namespace :notes do
  files = proc { Dir['{app,test}/**/*.coffee'].select { |f| File.file? f }.join " " }

  [:todo, :fixme, :optimize, :note].each do |tag|
    desc "Print all #{tag.upcase} annotations"
    task tag do
      sh "bundle exec dnote --ignore assets/images --label #{tag.upcase} #{files.call}", :verbose => false
    end
  end

  task :all do
    sh "bundle exec dnote --ignore assets/images #{files.call}", :verbose => false
  end
end

desc "Print all annotations (TODO,FIXME,NOTE,OPTIMIZE etc)"
task :notes => "notes:all"

namespace :test do
  desc "Compile tests and run them through phantom"
  task :all do 
    sh "bundle exec iridium test"
  end

  desc "Print console.log to stdout during tests"
  task :debug do 
    sh "bundle exec iridium test --debug"
  end
end

task :test => 'test:all'

task :default => :test
