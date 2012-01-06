define('models/activity', function(require) {
  require('ember');
  require('data');
  
  Radium.Activity = DS.Model.extend({
    // FIXME: Add array transform
    tags: [],
    timestamp: DS.attr('date'),
    owner: DS.hasOne(Radium.User, {embedded: true}),
    reference: 
  });
  
});