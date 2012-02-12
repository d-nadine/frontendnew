Radium.Sms = Radium.Message.extend({
  to: DS.attr('array'),
  smsSender: function() {
    return this.getPath('sender.id');
  }.property('sender').cacheable()
});