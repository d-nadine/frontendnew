define('models/sms', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./message');
  
  Radium.Sms = Radium.Message.extend({
    to: DS.attr('array'),
    smsSender: function() {
      return this.getPath('sender.id');
    }.property('sender').cacheable()
  });
  
  return Radium;
});