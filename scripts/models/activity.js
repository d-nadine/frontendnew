define('models/activity', function(require) {
  require('ember');
  require('data');
  
  Radium.Activity = DS.Model.extend({
    // FIXME: Add array transform
    tags: DS.attr('array'),
    timestamp: DS.attr('date'),
    // FIXME: DS.hasOne
    owner: DS.hasMany(Radium.User, {embedded: true}),
    // FIXME: This needs to process which activity type we're loading. 
    reference: {}
  });
  
});