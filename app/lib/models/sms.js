Radium.Sms = Radium.Message.extend({
  to: DS.attr('array'),
  sender: DS.hasOne('Radium.User'),
  smsSender: function() {
    return this.getPath('sender.id');
  }.property('sender').cacheable()
});