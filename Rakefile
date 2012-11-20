require 'bundler/setup'
require File.expand_path("../application.rb", __FILE__)

namespace :assets do
  desc "compiles the application"
  task :precompile do
    Iridium.application.compile
  end
end

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
