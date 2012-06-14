Radium.Sms = Radium.Message.extend({
  type: 'sms',
  to: DS.attr('array'),
  sender: DS.belongsTo('Radium.User')
});