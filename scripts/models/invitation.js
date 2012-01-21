define('models/invitation', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./message');
  
  Radium.Invitation = Radium.Message.extend({
    // FIXME: Add validation, state can only have pending, cancelled, or rescheduled
    state: DS.attr('string'),
    hash_key: DS.attr('string'),
    meeting: DS.hasOne('Radium.Meeting'),
    user: DS.hasOne('Radium.User')
  });
  
  return Radium;
});