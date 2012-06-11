Radium.Invitation = Radium.Message.extend({
  state: DS.attr('inviteState'),
  hash_key: DS.attr('string'),
  meeting: DS.belongsTo('Radium.Meeting'),
  user: DS.belongsTo('Radium.User', {key: 'user'})
});