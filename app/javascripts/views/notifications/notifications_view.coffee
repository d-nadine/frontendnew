require 'radium/views/drawer_view'

Radium.NotificationsView = Radium.DrawerView.extend
  templateName: 'radium/notifications'
  contentBinding: 'controller'

  remindersBinding: 'controller.reminders'
  notificationGroupsBinding: 'controller.notificationGroups'

  remindersListView: Ember.CollectionView.extend
    contentBinding: 'parentView.reminders'
    tagName: 'ul'
    itemViewClass: Em.View.extend
      attributeBindings: ['dataReminderId:data-reminder-id']
      templateName: 'radium/notifications/reminder'
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
    itemViewClass: Ember.View.extend
      layoutName: 'radium/layouts/notification_panel_item'
      attributeBindings: ['dataNotificationId:data-notification-id']
      referenceBinding: 'content.reference'

      dataNotificationId: (->
        @get('content.id')
      ).property('content')

      templateName: (->
        tag = @get 'content.tag'
        "radium/notifications/#{tag.replace('.', '_')}"
      ).property('content.tag')
