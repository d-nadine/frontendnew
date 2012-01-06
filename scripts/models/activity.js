define('models/activity', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Activity = Radium.Core.extend({
    // FIXME: Add array transform
    tags: DS.attr('array'),
    timestamp: DS.attr('date'),
    // FIXME: DS.hasOne
    owner: DS.hasMany(Radium.User, {embedded: true}),
    // FIXME: This needs to process which activity type we're loading. 
    reference: {}
  });
  
});