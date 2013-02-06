Radium.configure do
  # Minify JS and CSS
  config.pipeline.minify = true

  # Generate GZip version of files along with regular version
  config.pipeline.gzip = true

  # Generate an HTML5 Cache Manifest for offline support
  config.pipeline.manifest = true

  # Swap out entire handlebars library for just the runtime
  #
  # FIXME: revist this when we bump ember or use a production
  # ember build. The dev build does not precompile handlebars
  # templates (Ember.Select uses Handlebars.Compile). The production
  # version does this optimization.
  #
  # config.dependencies.swap :handlebars, "handlebars-runtime"

  # Module format for minispade: :string or :function
  config.minispade.module_format = :function

  # Override iridium-ember
  config.handlebars.compiler = proc { |source|
    "Ember.Handlebars.compile(#{source});"
  }

  config.handlebars.inline_compiler = nil
end
