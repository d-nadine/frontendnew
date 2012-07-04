Radium.Im = Radium.Message.extend({
  to: DS.hasMany('Radium.Contact'),
  sender: DS.belongsTo('Radium.User'),
  notes: DS.hasMany('Radium.Note', {embedded: true})
});