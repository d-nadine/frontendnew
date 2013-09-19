Radium.NotificationsPoller = Ember.Object.extend Radium.PollerMixin,
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
