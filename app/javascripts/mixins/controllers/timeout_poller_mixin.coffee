Radium.TimeoutPollerMixin = Ember.Mixin.create Radium.PollerMixin,
  interval: 1000
  timeOutInterval: 10000
  _timeout: null

  start: ->
    @_super.apply this, arguments

    @_timeout = setInterval(@finishSync.bind(this), @timeOutInterval)

  finishSync: ->
    throw new Error('You need to override finishSync in Radium.TimeoutPollerMixin')
