define('models/sms', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./message');
  
  Radium.SMS = Radium.Message.extend({
    // FIXME: Add back Sender object once I know what to do with it.
  });
  
  return Radium;
});