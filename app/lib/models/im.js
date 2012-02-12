Radium.Im = Radium.Message.extend({
  to: DS.hasMany('Radium.Contact'),
  imSender: function() {
    return this.getPath('sender.id');
  }.property('sender').cacheable()
});