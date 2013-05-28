Radium.Tag = Radium.Model.extend
  contacts: DS.hasMany('Radium.Contact')
  companies: DS.hasMany('Radium.Company')

  name: DS.attr('string')
  description: DS.attr('string')
