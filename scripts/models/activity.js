define('models/activity', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Activity = Radium.Core.extend({
    tags: DS.attr('array'),
    timestamp: DS.attr('date'),
    owner: DS.hasOne('Radium.User', {embedded: true}),
    // FIXME: This needs to process which activity type we're loading. 
    reference: {}
  });
  
  return Radium;
});