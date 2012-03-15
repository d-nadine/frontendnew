Radium.Im = Radium.Message.extend({
  to: DS.hasMany('Radium.Contact'),
  sender: DS.hasOne('Radium.User')
});