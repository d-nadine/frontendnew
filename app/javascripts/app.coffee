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

  # LOG_STACKTRACE_ON_DEPRECATION : true
  # LOG_BINDINGS                  : true
  # LOG_TRANSITIONS               : true
  # LOG_TRANSITIONS_INTERNAL      : true
  # LOG_VIEW_LOOKUPS              : true
  # LOG_ACTIVE_GENERATION         : true

  EMAIL_REGEX: /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/

  URL_REGEX: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/

window.Radium = Radium

Radium.deferReadiness()

Ember.RSVP.configure 'onerror', (e) ->
  return if e.message == "TransitionAborted"

  if e.hasOwnProperty 'responseText'
    text = """
      ================================
      Request failed with: #{e.status}
      status: #{e.statusText}
      response: #{e.responseText}
      ================================
      """

    return Ember.Logger.error(text)

  Ember.Logger.error e

require /lib\/radium\/base/

require 'lib/radium/computed'

requireAll /services/

require 'store'

require 'models'

require /^forms/

require 'routes'
requireAll /routes/

require 'views'

requireAll /components/

require 'lib/radium/checkable_mixin'
require 'lib/radium/selectable_mixin'

require 'controllers'

require /helpers/
require /mixins/
require /utils/

require 'debug'
