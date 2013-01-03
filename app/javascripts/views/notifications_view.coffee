Radium.NotificationsView = Ember.View.extend
  templateName: 'radium/notifications'
  controllerBinding: 'Radium.router.notificationsController'
  contentBinding: 'controller'
  remindersBinding: 'controller.reminders'
  notificationGroupsBinding: 'controller.notificationGroups'
  elementId: 'notifications'

  didInsertElement: ->
    @_super.apply this, arguments
    @isVisibleDidChange()

  isVisibleDidChange: (->
    notifications = $('#notifications')
    if @get('controller.isVisible')
      # TODO: in the future, it would be nice to handle window resize
      sidebar = $('#sidebar')
      width = sidebar.offset().left + sidebar.width()
      notifications.css width: width, left: -width
      Ember.run.next ->
        notifications.css left: 0
    else
      notifications.css(left: -notifications.width() - 10)
  ).observes('controller.isVisible')

  remindersListView:  Ember.CollectionView.extend
    contentBinding: 'parentView.reminders'
    tagName: 'ul'
    elementId: 'reminders'
    itemViewClass: Em.View.extend
      attributeBindings: ['dataReminderId:data-reminder-id']
      templateName: 'radium/reminder'
      layoutName: 'radium/layouts/notification_panel_item'
      referenceBinding: 'content.reference'
      dateBinding: 'reference.feedDate'

      dataReminderId: (->
        @get('content.id')
      ).property('content')

      description: (->
        @get('reference.topic') || @get('reference.description')
      ).property('reference.topic', 'reference.description')

  notificationsListView: Ember.CollectionView.extend
    tagName: 'ul'
    itemViewClass: Radium.NotificationItemView
