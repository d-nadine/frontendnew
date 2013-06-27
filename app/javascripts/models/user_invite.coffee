Radium.UserInvite = Radium.Model.extend
  inviteSent: DS.attr('date')
  name: DS.attr('string')

Radium.ResendUserInvite = Radium.Model.extend
  inviteSent: DS.attr('date')
  name: DS.attr('string')

Radium.UserInvite.FIXTURES = []
Radium.ResendUserInvite.FIXTURES = []