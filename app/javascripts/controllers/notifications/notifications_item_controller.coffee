Radium.NotificationsItemController = Radium.ObjectController.extend
  actions:
    deleteNotification: ->
      @get('model').deleteRecord()
      @get('store').commit()
      @get('parentController').send 'showMore'
