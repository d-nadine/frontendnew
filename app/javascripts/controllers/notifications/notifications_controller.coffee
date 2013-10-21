Radium.NotificationsController = Radium.ArrayController.extend
  actions:
    deleteAllNotifications: ->
      return unless @get('model.length')

      items = @get('model').toArray()

      items.forEach (item) =>
        item.deleteRecord()

      @get('store').commit()

  itemController: 'notificationsItem'
