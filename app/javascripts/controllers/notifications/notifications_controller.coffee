Radium.NotificationsController = Radium.ArrayController.extend
  itemController: 'notificationsItem'
  arrangedContent: ( ->
    content = @get('content').slice()

    return Ember.A() unless content.get('length')

    content = content.sort (a, b) ->
      Ember.DateTime.compare a.get('time'), b.get('time')

    content
  ).property('content.[]')

  deleteAllNotifications: ->
    return unless @get('model.length')

    @get('model').forEach (notification) =>
      notification.deleteRecord()

    @get('store').commit()
