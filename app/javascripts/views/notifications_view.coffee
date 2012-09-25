Radium.NotificationsView = Ember.View.extend
  templateName: 'notifications'
  controllerBinding: 'Radium.router.notificationsController'
  contentBinding: 'controller'
  remindersBinding: 'controller.reminders'
  messagesBinding: 'controller.messages'
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
      templateName: 'reminder'
      layoutName: 'notification_panel_item_layout'
      referenceBinding: 'content.reference'
      dateBinding: 'reference.feedDate'

      description: (->
        @get('reference.topic') || @get('reference.description')
      ).property('reference.topic', 'reference.description')

      click: ->
        reference = @get 'content.reference'
        Radium.Utils.showItem reference

  messagesListView:  Ember.CollectionView.extend
    contentBinding: 'parentView.messages'
    tagName: 'ul'
    elementId: 'messages'
    itemViewClass: Em.View.extend
      templateName: 'message'
      layoutName: 'notification_panel_item_layout'

  notificationsListView: Ember.CollectionView.extend
    tagName: 'ul'
    itemViewClass: Radium.NotificationItemView
