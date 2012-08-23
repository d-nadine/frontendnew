Radium.Campaign = Radium.Core.extend
  isEditable: true
  name: DS.attr('string')
  endsAt: DS.attr('date', key: 'ends_at')
  currency: DS.attr('string')
  target: DS.attr('number')
  isPublic: DS.attr('boolean', key: 'is_public')
  user: DS.belongsTo('Radium.User', key: 'user_id')
