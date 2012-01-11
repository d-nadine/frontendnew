define('radium', function(require) {
  require('jquery');
  require('ember');
  require('data');
  require('mixins/data');
  
  // Set up the Ember Application
  return Ember.Application.create({
    store: DS.Store.create({
      adapter: 'DS.radiumFixtureAdapter'
    })
  });

});