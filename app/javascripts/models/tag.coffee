Radium.Tag = Radium.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')
  contact: DS.hasMany('Radium.Contact')
  company: DS.hasMany('Radium.Company')

  displayName: Ember.computed.alias 'name'
  # FIXME: uncomment when API has user
  # user: DS.belongsTo('Radium.User')
