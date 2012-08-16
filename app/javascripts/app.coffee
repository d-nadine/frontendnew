Radium = Em.Application.create
  init: ->
    @_super()
    @set('_api', $.cookie('user_api_key'))

window.Radium = Radium

require 'radium/router'
require 'radium/controllers/application'
require 'radium/controllers/me'
require 'radium/controllers/login'
require 'radium/controllers/main'
require 'radium/controllers/feed'
