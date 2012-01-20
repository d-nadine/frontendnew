define('models/im', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./message');
  
  Radium.Im = Radium.Message.extend({
    to: DS.hasMany('Radium.Contact'),
    imSender: function() {
      return this.getPath('sender.id');
    }.property('sender').cacheable()
  });
  
  return Radium;
});