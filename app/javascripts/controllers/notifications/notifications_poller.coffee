Radium.NotificationsPoller = Ember.Object.extend Radium.PollerMixin,
  onPoll: ->
    existing = Radium.Notification.all().slice()

    Radium.Notification.find({page:1, page_size: 20}).then (records) ->
      return unless records.get('length')

      delta = records.toArray().reject (record) ->
                existing.contains(record) || record.get('read')

      console.log "#{delta.length} new notifications"

      return unless delta.length

      Radium.NotificationsTotal.find({}).then (result) ->
        total = result.get('firstObject.total')

        Radium.set('notifyCount', total)
