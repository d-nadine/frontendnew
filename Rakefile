task :compile do
  ENV['RACK_ENV'] = 'production'
  require './radium'

  Radium.new.compile_assets
end
