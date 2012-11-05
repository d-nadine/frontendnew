Radium.Campaign = Radium.Core.extend
  isEditable: true
  name: DS.attr('string')
  endsAt: DS.attr('date')
  currency: DS.attr('string')
  target: DS.attr('number')
  isPublic: DS.attr('boolean')
  user: DS.belongsTo('Radium.User')
  contacts: DS.hasMany('Radium.Contact')

  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')
