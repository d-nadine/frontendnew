# First off, require all the custom additions and code
# we need to be available globally
require /lib\/patches/

require 'lib/ember/arrangable_mixin'
require 'lib/ember/filterable_mixin'
require 'lib/ember/datetime'
require 'lib/ember/computed'

require 'lib/string/inflector'

Radium = Em.Application.create
  rootElement: '#application'
  customEvents:
    blur: 'blur'
  timezone: Ember.DateTime.create().get('timezone')
  LOG_STACKTRACE_ON_DEPRECATION : true
  LOG_BINDINGS                  : true
  LOG_TRANSITIONS               : true
  LOG_TRANSITIONS_INTERNAL      : true
  LOG_VIEW_LOOKUPS              : true
  LOG_ACTIVE_GENERATION         : true

window.Radium = Radium

Radium.deferReadiness()

Ember.RSVP.configure 'onerror', (e) ->
  return if e.message == "TransitionAborted"

  console.log e.message
  console.log e.stack

require /lib\/radium\/base/

require 'lib/radium/computed'

require 'lib/radium/run_when_loaded_mixin'

require 'store'

require 'routes'
requireAll /routes/

require 'models'

require /^forms/

requireAll /components/

require 'views'

require 'lib/radium/checkable_mixin'
require 'lib/radium/selectable_mixin'

require 'controllers'

require /helpers/

require 'debug'
