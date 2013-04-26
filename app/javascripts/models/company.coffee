Radium.Company = Radium.Model.extend
  contacts: DS.hasMany('Radium.Contact')
  addresses: DS.hasMany('Radium.Address')
  activities: DS.hasMany('Radium.Activity')

  primaryContact: DS.belongsTo('Radium.Contact')
  primaryAddress: Radium.computed.primary 'addresses'

  name: DS.attr('string')
  website: DS.attr('string')
  address: DS.belongsTo('Radium.Address')
