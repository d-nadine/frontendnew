define('radium', function(require) {
  require('jquery');
  require('ember');
  require('data');
  // var adapter = require('core/adapter'); Add this back when testing with dev server.
  require('mixins/data');

    
  // Set up the Ember Application
  return Ember.Application.create({
    store: DS.Store.create({
      adapter: 'DS.fixtureAdapter'
    })
  });

});