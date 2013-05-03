Radium.Company = Radium.Model.extend
  contacts: DS.hasMany('Radium.Contact')
  addresses: DS.hasMany('Radium.Address')
  activities: DS.hasMany('Radium.Activity')

  tags: DS.hasMany('Radium.Tag')

  primaryContact: DS.belongsTo('Radium.Contact', inverse: null)
  primaryAddress: Radium.computed.primary 'addresses'

  name: DS.attr('string')
  website: DS.attr('string')
  addresses: DS.hasMany('Radium.Address')
  primaryAddress: Radium.computed.primary 'addresses'
