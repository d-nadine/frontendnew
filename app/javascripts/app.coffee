require 'radium/lib/transforms'

Radium = Em.Application.create
  init: ->
    @_super()
    @set('_api', $.cookie('user_api_key'))

window.Radium = Radium

$.ajaxSetup
  dataType: 'json'
  contentType: 'application/json'
  headers:
    "X-Radium-User-API-Key": Radium.get('_api')
    "Accept": "application/json"

require 'radium/router'
require 'radium/controllers/application'
require 'radium/controllers/me'
require 'radium/controllers/login'
require 'radium/controllers/main'
require 'radium/controllers/feed'

require 'radium/helpers/date_helper'
