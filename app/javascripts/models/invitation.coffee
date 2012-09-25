Radium.Invitation = Radium.Message.extend
  state: DS.attr('inviteState')
  meeting: DS.belongsTo('Radium.Meeting')
  user: DS.belongsTo('Radium.User')
