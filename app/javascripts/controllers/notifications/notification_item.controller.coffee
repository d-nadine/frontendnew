Radium.NotificationItemController = Radium.ObjectController.extend
  timeInHumanFormat: ( ->
    @get('time').toHumanFormat()
  ).property('time')

Radium.NotificationsAssignController = Radium.NotificationItemController.extend()

Radium.NotificationsAssignContactController = Radium.NotificationsAssignController.extend()

Radium.NotificationsAssignDealController = Radium.NotificationsAssignController.extend()

Radium.NotificationsAssignTodoController = Radium.NotificationsAssignController.extend
  isOverdue: ( ->
    @get('reference.overdue')
  ).property('reference')

