Radium.Company = Radium.Model.extend
  name: DS.attr('string')
  contacts: DS.hasMany('Radium.Contact')
  primaryContact: DS.belongsTo('Radium.Contact')
