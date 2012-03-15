Radium.Sms = Radium.Message.extend({
  to: DS.attr('array'),
  sender: DS.hasOne('Radium.User')
});