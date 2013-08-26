Radium.NotificationsItemController = Radium.ObjectController.extend
  deleteNotification: -> 
    @get('model').deleteRecord()
    @get('store').commit()

