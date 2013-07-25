Radium.UserInvitation = Radium.Model.extend
  email: DS.attr('string')
  sentAt: DS.attr('datetime')

Radium.UserInvitationDelivery = Radium.Model.extend
  userInvitation: DS.belongsTo('Radium.UserInvitation')
