Radium.Tag = Radium.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')
  contacts: DS.hasMany('Radium.Contact')
  companies: DS.hasMany('Radium.Company', inverse: 'tags')

  displayName: Ember.computed.alias 'name'
