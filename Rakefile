require 'bundler/setup'
require File.expand_path("../application.rb", __FILE__)

namespace :assets do
  desc "Compiles the application"
  task :precompile do
    Iridium.application.compile
  end
end

desc "Compiles the application"
task :compile => "assets:precompile"

namespace :test do
  desc "Run all tests"
  task :all do
    sh "bundle exec iridium test"
  end

  desc "Run all tests in debugging mode"
  task :debug do
    sh "bundle exec iridium test --log-level=info"
  end
end

task :test => 'test:all'

namespace :build do
  vendor_path = File.expand_path "../vendor/", __FILE__
  vendor_js_path = File.expand_path "../vendor/javascripts", __FILE__

  desc "Build ember and copy into vendor/javascripts"
  task :ember do
    if File.directory? "#{vendor_path}/ember.js"
      sh "cd #{vendor_path}/ember.js && BUNDLE_GEMFILE=#{vendor_path}/ember.js/Gemfile rake dist"
      sh %Q{cd #{vendor_path}/ember.js && echo "// $(git log -n 1 --format='%h (%ci)')" > #{vendor_js_path}/ember.js}
      sh %Q{cat #{vendor_path}/ember.js/dist/ember.prod.js >> #{vendor_js_path}/ember.js}
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

task :default => :test
