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

# First off, require all the custom additions and code
# we need to be available globally
require 'ember/datetime'
require 'string/inflector'

require 'foundry'
require 'ember/filterable_mixin'

require 'radium/store'

require 'radium/router'

require 'radium/mixins'

require 'radium/models'
requireAll /radium\/views/
requireAll /radium\/controllers/

require 'radium/feed'

require /radium\/helpers/

require 'radium/views/inbox/sidebar_mailitem_view'
require 'radium/views/inbox/inbox_sidebar_view'
require 'radium/views/inbox/inbox_view'
require 'radium/views/inbox/email_view'
require 'radium/controllers/inbox/inbox_controller'
require 'radium/controllers/inbox/inbox_sidebar_controller'
require 'radium/controllers/inbox/email_controller'

require 'radium/factories'
