Radium.NotificationsController = Radium.ArrayController.extend
  sortProperties: ['time']
  sortAscending: false
  needs: ['messagesSidebar']
  isDeleting: false
  actions:
    deleteAllNotifications: ->
      return unless @get('model.length')

      @set 'isDeleting', true

      setTimeout ->
        Radium.Notification.all().compact().forEach (notification) ->
          notification.unloadRecord()
      , 0

      currentUser = @get("currentUser")

      job = Radium.DestroyNotificationsJob.createRecord
        user: currentUser

      job.one 'didCreate', =>
        @send 'flashSuccess', "All Notifications Deleted"
        @set 'isDeleting', true

      job.one 'becameError', =>
        @send 'flashError', "An error has occurred trying to delete all notifications."
        @set 'isDeleting', true

      @get('store').commit()

    showEmail: (email) ->
      @get('controllers.messagesSidebar').send 'reset'
      @transitionToRoute 'emails.show', "inbox", email

  itemController: 'notificationsItem'

  drawerOpen: false
