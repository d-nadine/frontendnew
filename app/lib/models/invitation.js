Radium.Invitation = Radium.Message.extend({
  state: DS.attr('inviteState'),
  hash_key: DS.attr('string'),
  meeting: DS.hasOne('Radium.Meeting'),
  user: DS.hasOne('Radium.User')
});