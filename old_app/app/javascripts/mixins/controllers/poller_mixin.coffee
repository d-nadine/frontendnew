Radium.PollerMixin = Ember.Mixin.create Ember.Evented,
  interval: 30000  # 30 seconds
  _timer: null
  isPolling: false

  init: ->
    @_super.apply this, arguments
    @onPoll()

  start: ->
    return if @get('isPolling')

    @set 'isPolling', true
    @_timer = setInterval(@onPoll.bind(this), @interval)

  stop: ->
    @set 'isPolling', false
    clearInterval(@_timer) if @_timer

  onPoll: ->
    throw new Error('You need to override onPoll in Radium.PollerMixin')
