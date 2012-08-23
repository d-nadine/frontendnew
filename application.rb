class Radium < Iridium::Application
  config.load 'minispade', 'jquery', 'handlebars', 'ember', 'ember-data'

  # Proxy the API so we can update it per ENV and hide access tokens
  # from Javscript
  config.proxy '/api', 'http://api.radiumcrm.com'

  # Add our API key to every API request going through the proxy
  middleware.add_header 'X-Radium-Developer-API-Key', '26233b7b68290c7c7d4eec03643d0cf3e9b88ba8', :url => /^\/api/
end
