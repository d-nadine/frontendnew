namespace :assets do
  task :precompile do
    ENV['RACK_ENV'] = 'production'

    require './radium'
    raise unless Radium.new.production?

    Radium.new.compile_assets
  end
end
