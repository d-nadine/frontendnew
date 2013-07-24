Radium.UserInvitation = Radium.Model.extend
  email: DS.attr('string')

Radium.ResendUserInvite = Radium.Model.extend
  inviteSent: DS.attr('date')
  email: DS.attr('string')
