Radium = Em.Application.create
  autoinit: false
  rootElement: '#application'
  ready: ->
    @_super()
    # FIXME: Stub out authentication
    @set 'router.currentUser', Radium.User.find(1)

  didBecomeCompletelyReady: Ember.K
  didBecomeReady: ->
    @_super.apply @, arguments

    @didBecomeCompletelyReady()

window.Radium = Radium

require 'radium/store'

require 'radium/router'

require 'radium/lib'

require 'radium/mixins'

require 'radium/models'
require 'radium/views'
require 'radium/controllers'

require 'radium/feed'

require 'radium/helpers/date_helper'
require 'radium/helpers/time_helper'

require 'radium/factories'
