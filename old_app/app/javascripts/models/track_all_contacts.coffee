Radium.TrackAllContacts = Radium.Model.extend
  user: DS.belongsTo("Radium.User")
  account: DS.belongsTo("Radium.Account")
  tracked: DS.attr("boolean")