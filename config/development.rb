class Radium < Iridium::Application
  # Stub out an authenticated user so we can develop.
  # You can change the api key by updating config/settings.yml
  config.middleware.add_cookie 'user_api_key', config.settings.user_api_key

  # Minify JS and CSS
  config.pipeline.minify = false

  # Precompile handlebars templates
  config.handlebars.precompile = false

  # Module format for minispade: :string or :function
  config.minispade.module_format = :string
end
