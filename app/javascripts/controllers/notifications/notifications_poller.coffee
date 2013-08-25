Radium.NotificationsPoller = Ember.Object.extend
  interval: 30000  # 30 seconds
  _timer: null

  init: ->
    @onPoll()

  start: ->
    @_timer = setInterval(@onPoll.bind(this), @interval)

  stop: ->
    clearInterval(@_timer) if @_timer

  onPoll: ->
    console.log "Polling starting at #{Ember.DateTime.create().toFullFormat()}"
    Radium.Notification.find().then ->
      console.log "Polling ended at #{Ember.DateTime.create().toFullFormat()}"
