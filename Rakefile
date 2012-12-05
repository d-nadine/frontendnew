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

desc "Compile tests for browser"
task :compile_tests do
  output_dir = File.expand_path "../test_site", __FILE__

  FileUtils.rm_rf output_dir if File.directory? output_dir
  FileUtils.mkdir_p output_dir

  loader_template = <<-erb
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <title>Unit Tests</title>
        <link rel="stylesheet" href="application.css">
        <link rel="stylesheet" href="http://code.jquery.com/qunit/qunit-1.10.0.css">

        <script type="text/javascript" src="application.js"></script>
        <script type="text/javascript" src="qunit.js"></script>

        <script type="text/javascript">
          QUnit.config.autorun = false
        </script>

        <% scripts.each do |script| %> 
          <script type="text/javascript" src="<%= script %>"></script>
        <% end %>
      </head>

      <body>
        <div id="application"></div>
        <div id="qunit"></div>
        <div id="qunit-fixture"></div>

        <script type="text/javascript">
          minispade.require('radium/boot');
        </script>

        <script type="text/javascript">
          QUnit.load()
        </script>
      </body>
    </html>
  erb

  sh "cp -r site/* #{output_dir}", :verbose => false

  sh "cp -r test/* #{output_dir}", :verbose => false

  # Now compile all the coffeescript stuff
  Dir["#{output_dir}/**/*.coffee"].each do |test_file|
    js_file = test_file.gsub /\.coffee$/, ".js"
    File.open js_file, "w" do |js|
      js.puts CoffeeScript.compile(File.read(test_file))
      FileUtils.rm_rf test_file
    end
  end

  # Copy qunit over
  FileUtils.cp "#{Iridium.js_lib_path}/iridium/qunit.js", "#{output_dir}/qunit.js"

  # Now organize all the scripts
  scripts = []

  Dir.chdir output_dir do
    Dir["support/**/*.js"].each do |script|
      scripts << script
    end

    Dir["**/*_test.js"].each do |script|
      scripts << script
    end
  end

  File.open "#{output_dir}/tests.html", "w" do |html|
     html.puts ERB.new(loader_template).result(binding)
  end
end
