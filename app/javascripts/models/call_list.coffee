Radium.CallList = Radium.Core.extend
  isEditable: true
  description: DS.attr("string")
  user: DS.belongsTo("Radium.User")
  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')
