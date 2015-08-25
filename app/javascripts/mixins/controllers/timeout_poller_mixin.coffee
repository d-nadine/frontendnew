require 'mixins/controllers/poller_mixin'
require 'mixins/controllers/timeout_poller_mixin'

Radium.TimeoutPollerMixin = Ember.Mixin.create Radium.PollerMixin,
  interval: 1000
  timeOutInterval: 5000
  _timeout: null

  start: ->
    @_super.apply this, arguments

    @_timeout = setInterval(@finishSync.bind(this), @timeOutInterval)

  finishSync: ->
    throw new Error('You need to override finishSync in Radium.TimeoutPollerMixin')
