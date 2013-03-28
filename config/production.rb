Radium.configure do
  # Minify JS and CSS
  config.pipeline.minify = true

  # Generate GZip version of files along with regular version
  config.pipeline.gzip = true

  # Generate an HTML5 Cache Manifest for offline support
  config.pipeline.manifest = false

  # Swap out entire handlebars library for just the runtime
  config.dependencies.swap :handlebars, "handlebars.runtime"

  # Module format for minispade: :string or :function
  config.minispade.module_format = :function

  config.middleware.use Rack::Auth::Basic do |username, password|
    password == 'whynotactinium' && username == 'radium'
  end
end
