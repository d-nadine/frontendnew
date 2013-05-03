Radium.Company = Radium.Model.extend
  contacts: DS.hasMany('Radium.Contact')
  primaryContact: DS.belongsTo('Radium.Contact')
  addresses: DS.hasMany('Radium.Address')
  primaryAddress: Radium.computed.primary 'addresses'
  activities: DS.hasMany('Radium.Activity')

  name: DS.attr('string')
