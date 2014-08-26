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
Radium.NotificationsScheduledEmailController = Radium.NotificationsAssignController.extend()
Radium.NotificationsReplyEmailController = Radium.NotificationsAssignController.extend()
Radium.NotificationsNoReplyEmailController = Radium.NotificationsAssignController.extend()
Radium.NotificationsNotRepliedEmailController = Radium.NotificationsAssignController.extend()
Radium.NotificationsNewContactImportJobController = Radium.NotificationsAssignController.extend()
Radium.NotificationsNewAccountController = Radium.NotificationsAssignController.extend()
Radium.NotificationsPrimaryContactDeletedDealController = Radium.NotificationItemController.extend()

Radium.NotificationsNewInvitationController = Radium.NotificationsAssignController.extend
  actions:
    accept: ->
      @send 'updateSattus', 'confirmed'

    reject: ->
      @send 'updateSattus', 'rejected'

    updateSattus: (status) ->
      reference = @get('reference')

      reference.set 'status', status

      reference.one 'didUpdate', =>
        @send 'flashSuccess', "Invitation #{status}"

      reference.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      reference.one 'becameError', (result) =>
        @send 'flashError', "an error happened and the profile could not be updated"
        @resetModel()

      @get('store').commit()
