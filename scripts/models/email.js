define('models/email', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./message');
  
  Radium.Email = Radium.Message.extend({
    to: DS.attr('array'),
    from: DS.attr('array'),
    subject: DS.attr('string'),
    html: DS.attr('string')
    // FIXME: Add back Sender object once I know what to do with it.
  });
  
  return Radium;
});