Radium.NotificationItemController = Radium.ObjectController.extend
  timeInHumanFormat: ( ->
    @get('time').toHumanFormat()
  ).property('time')

Radium.NotificationsAssignController = Radium.NotificationItemController.extend()

Radium.NotificationsAssignContactController = Radium.NotificationsAssignController.extend()

Radium.NotificationsAssignDealController = Radium.NotificationsAssignController.extend()

Radium.NotificationsAssignTodoController = Radium.NotificationsAssignController.extend()

Radium.NotificationsLeadEmailController = Radium.NotificationsAssignController.extend()
  
Radium.NotificationsNewUserController = Radium.NotificationsAssignController.extend()

Radium.NotificationsNewController = Radium.NotificationsAssignController.extend()
