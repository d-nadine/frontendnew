Radium.Invitation = Radium.Message.extend({
  state: DS.attr('inviteState'),
  hashKey: DS.attr('string', {key: 'hash_key'}),
  meeting: DS.belongsTo('Radium.Meeting', {key: 'meeting'}),
  user: DS.belongsTo('Radium.User', {key: 'user'})
});