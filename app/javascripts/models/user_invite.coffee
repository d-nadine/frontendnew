Radium.UserInvitation = Radium.Model.extend
  email: DS.attr('string')
  sentAt: DS.attr('datetime')
  confirmed: DS.attr('boolean')

Radium.UserInvitationDelivery = Radium.Model.extend
  userInvitation: DS.belongsTo('Radium.UserInvitation')
