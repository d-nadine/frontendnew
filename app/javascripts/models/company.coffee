Radium.Company = Radium.Model.extend
  contacts: DS.hasMany('Radium.Contact')
  addresses: DS.hasMany('Radium.Address')
  activities: DS.hasMany('Radium.Activity')

  tags: DS.hasMany('Radium.Tag')
  addresses: DS.hasMany('Radium.Address')

  primaryContact: DS.belongsTo('Radium.Contact', inverse: null)
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  website: DS.attr('string')
  about: DS.attr('string')

  primaryAddress: Radium.computed.primary 'addresses'
