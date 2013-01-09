Radium.Invitation = Radium.Core.extend
  state: DS.attr('string')
  meeting: DS.belongsTo('Radium.Meeting')
  user: DS.belongsTo('Radium.User')
