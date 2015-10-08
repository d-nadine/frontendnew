Radium.configure do
  # Minify JS and CSS
  config.pipeline.minify = false

  # Precompile handlebars templates
  config.handlebars.precompile = false

  # Module format for minispade: :string or :function
  config.minispade.module_format = :string

  # Also compile the tests for testing
  config.pipeline.compile_tests = true
end
