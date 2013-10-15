Radium.NotificationsController = Radium.ArrayController.extend
  itemController: 'notificationsItem'

  deleteAllNotifications: ->
    return unless @get('model.length')

    @get('model').forEach (notification) =>
      notification.deleteRecord()

    @get('store').commit()
