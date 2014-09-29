# First off, require all the custom additions and code
# we need to be available globally
require /lib\/patches/

require 'lib/ember/datetime'
require 'lib/ember/computed'

require 'lib/string/inflector'

FastClick.attach(document.body)

window.number_of_clicks = 0

document.addEventListener  'click', ->
          window.Intercom "update",
            increments:
              number_of_clicks: 1
          window.Intercom('reattach_activator')
        , false

Radium = Em.Application.createWithMixins
  rootElement: '#application'
  customEvents:
    blur: 'blur'

  timezone: Ember.DateTime.create().get('timezone')
  title: 'Radium'
  notifyCount: 0

  # LOG_STACKTRACE_ON_DEPRECATION : true
  # LOG_BINDINGS                  : true
  # LOG_TRANSITIONS               : true
  # LOG_TRANSITIONS_INTERNAL      : true
  # LOG_VIEW_LOOKUPS              : true
  # LOG_ACTIVE_GENERATION         : true

  titleChanged: Ember.observer 'notifyCount', ->
    title = @get('title')
    notifyCount = @get('notifyCount')

    if notifyCount
      title = "(#{notifyCount}) #{title}"

    window.setTimeout ->
      document.title = "."
      document.title = title
    , 200

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

require 'views'

requireAll /components/

require 'lib/radium/checkable_mixin'
require 'lib/radium/selectable_mixin'

require 'controllers'

require /helpers/
require /mixins/

require 'debug'
