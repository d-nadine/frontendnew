Radium.NotificationsController = Radium.ArrayController.extend
  sortProperties: ['time']
  sortAscending: false
  needs: ['messagesSidebar']
  isDeleting: false
  actions:
    loadNotifications: ->
      @dataset.expand()

    deleteAllNotifications: ->
      return unless @get('model.length')

      @set 'isDeleting', true

      @send 'toggleNotifications'

      notificationPoller = Radium.get('notificationPoller')
      notificationPoller.stop()

      self = this

      complete = ->
        Ember.run.next ->
          self.set('isDeleting', false)
          notificationPoller.start()

      setTimeout ->
        Radium.Notification.all().compact().forEach (notification) ->
          notification.unloadRecord()
      , 0

      currentUser = @get("currentUser")

      job = Radium.DestroyNotificationsJob.createRecord
        user: currentUser

      job.one 'didCreate', =>
        @send 'flashSuccess', "All Notifications Deleted"
        complete()

      job.one 'becameError', =>
        @send 'flashError', "An error has occurred trying to delete all notifications."
        complete()

      @get('store').commit()

    showEmail: (email) ->
      @get('controllers.messagesSidebar').send 'reset'
      @transitionToRoute 'emails.show', "inbox", email

  itemController: 'notificationsItem'

  drawerOpen: false

  setup: ( ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Notification
  ).on('init')
