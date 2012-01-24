define('models/activity', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Activity = Radium.Core.extend({
    tags: DS.attr('array'),
    timestamp: DS.attr('date'),
    test: DS.hasOne('Radium.User', {
      embedded: true
    }),
    // owner: DS.hasOne('Radium.User', {embedded: true}),
    owner: DS.hasOneReference({
      embedded: true,
      namespace: 'Radium'
    }),
    reference: DS.hasOneReference({
      embedded: true,
      namespace: 'Radium'
    })
  });
  
  return Radium;
});