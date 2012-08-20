require 'radium/lib/adapter'
require 'radium/lib/store'
require 'radium/lib/transforms'

Radium = Em.Application.create
  store: DS.RadiumStore.create()
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

require 'radium/lib/extended_record_array'

require 'radium/router'

require 'radium/helpers/date_helper'

require 'radium/models/core'
require 'radium/models/todo'
require 'radium/models/account'
require 'radium/models/feed_section'
require 'radium/models/person'
require 'radium/models/user'

require 'radium/controllers/application_controller'
require 'radium/controllers/me_controller'
require 'radium/controllers/login_controller'
require 'radium/controllers/main_controller'
require 'radium/controllers/feed_controller'
require 'radium/controllers/topbar_controller'

require 'radium/views/application_view'
require 'radium/views/login_view'
require 'radium/views/main_view'
require 'radium/views/feed_view'
require 'radium/views/feed_activity_view'
require 'radium/views/todo_view_mixin'
require 'radium/views/feed_item_view'
require 'radium/views/topbar_view'

require 'radium/templates/feed/feed_todo'
require 'radium/templates/topbar'
