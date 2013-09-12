Radium.PollerMxin = Ember.Mixin.create
  interval: 30000  # 30 seconds
  _timer: null

  init: ->
    @_super.apply this, arguments
    @onPoll()

  start: ->
    @_timer = setInterval(@onPoll.bind(this), @interval)

  stop: ->
    clearInterval(@_timer) if @_timer

  onPoll: ->
    throw new Error('You need to override onPoll in Radium.PollerMxin') 
