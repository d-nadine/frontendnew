Radium.Sender = DS.Model.extend({
  user: DS.belongsTo('Radium.User', {key: 'user'})
});

Radium.Email = Radium.Message.extend({
  to: DS.attr('array'),
  from: DS.attr('array'),
  subject: DS.attr('string'),
  html: DS.attr('string'),
  sender: DS.belongsTo('Radium.Sender', {key: 'sender'})
});