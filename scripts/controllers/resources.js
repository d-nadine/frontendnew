/**
  Controller manages all the different main resource types. Currently used
  for the activity feed filter.
*/

define('controllers/resources', function(require) {
  require('ember');
  var Radium = require('radium');
  
  Radium.resourcesController = Ember.ArrayProxy.create({
    content: [
      Ember.Object.create({
        title: 'Everything', shortname: 'everything', isMain: true
      }),
      Ember.Object.create({
        title: 'Todos', shortname: 'todos', isMain: false
      }),
      Ember.Object.create({
        title: 'Meetings', shortname: 'meetings', isMain: false
      }), 
      Ember.Object.create({
        title: 'Phone Call', shortname: 'phonecalls', isMain: false
      }),
      Ember.Object.create({
        title: 'Deals', shortname: 'deals', isMain: false
      }),
      Ember.Object.create({
        title: 'Messages', shortname: 'messages', isMain: false
      }),
      Ember.Object.create({
        title: 'Discussions', shortname: 'discussions', isMain: false
      }), 
      Ember.Object.create({
        title: 'Activity', shortname: 'Activity', isMain: true
      }), 
      Ember.Object.create({
        title: 'Pipeline', shortname: 'Pipeline', isMain: true
      })
    ]
  });
  
  return Radium;
});