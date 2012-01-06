define('models/im', function(require) {
  
  require('ember');
  require('data');
  require('./message');
  
  Radium.IM = Radium.Message.extend({
    // FIXME: Add back Sender object once I know what to do with it.
  });
});