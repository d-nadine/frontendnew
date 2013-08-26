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
    existing = Radium.Notification.all().slice()

    Radium.Notification.find({}).then (records) ->
      return unless records.get('length')

      delta = records.toArray().reject (record) =>
                existing.contains(record) || record.get('read')

      console.log "#{delta.length} new notifications"

      return unless delta.length

      notifyCount = Radium.get('notifyCount')

      Radium.set('notifyCount', delta.length + notifyCount)
