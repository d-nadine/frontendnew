Radium.NotificationsController = Radium.ArrayController.extend
  sortProperties: ['time']
  sortAscending: false
  needs: ['messagesSidebar']
  actions:
    deleteAllNotifications: ->
      return unless @get('model.length')

      items = @get('model').toArray()

      items.forEach (item) =>
        item.deleteRecord()

      @get('store').commit()

    showEmail: (email) ->
      @get('controllers.messagesSidebar').send 'reset'
      @transitionToRoute 'emails.show', "inbox", email

  itemController: 'notificationsItem'

  drawerOpen: false
