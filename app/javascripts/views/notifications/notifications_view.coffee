require 'views/drawer_view'

Radium.NotificationsView = Radium.DrawerView.extend
  contentBinding: 'controller'

  remindersBinding: 'controller.reminders'
  notificationGroupsBinding: 'controller.notificationGroups'

  notificationsListView: Ember.CollectionView.extend
    tagName: 'ul'
    classNames: ['unstyled']
    itemViewClass: Ember.View.extend
      layoutName: 'layouts/notification_panel_item'
      attributeBindings: ['dataNotificationId:data-notification-id']
      referenceBinding: 'content.reference'

      dataNotificationId: (->
        @get('content.id')
      ).property('content')

      templateName: (->
        tag = @get 'content.tag'
        "notifications/#{tag.replace('.', '_')}"
      ).property('content.tag')
