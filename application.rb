require 'iridium'
require 'iridium-ember'

if defined?(Bundler) 
  Bundler.require :default, Iridium.env
end

class Radium < Iridium::Application
  # Specify vendor load order. Files will be concatenated in the
  # declared order. Undeclared files will be concatentated after
  # all declared files
  config.dependencies.insert_after :ember, 'ember-data'

  # Specify a different place to load your templates. All templates
  # will be added to Javascript array specified here:
  # 
  # Example:
  #   config.handlebars.target = "TEMPLATES"
  #
  #   // now in Javascript
  #   window.TEMPLATES['foo'] // templated named foo
  #
  # config.handlebars.target = "Ember.TEMPLATES"

  # Specify a different handlebars compiler to use. This is not the
  # the same as the precompiler! This proc returns a Javascript snippet
  # used to compile the raw template. It's written directly into the
  # final application.js
  # 
  # Example for Ember:
  #
  # config.handlebars.compiler = proc { |source| "Ember.Handlebars.compile(#{source});" }

  # Proxy the API so we can update it per ENV and hide access tokens
  # from Javscript
  proxy '/api', 'http://api.radiumcrm.com'

  # Add our API key to every API request going through the proxy
  config.middleware.add_header 'X-Radium-Developer-API-Key', '26233b7b68290c7c7d4eec03643d0cf3e9b88ba8', :url => /^\/api/
end
