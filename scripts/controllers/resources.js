/**
  Controller manages all the different main resource types. Currently used
  for the activity feed filter.
*/

define('controllers/resources', function(require) {
  require('ember');
  require('radium');
  
  Radium.resourcesController = Ember.ArrayProxy.create({
    content: [
      Ember.Object.create({title: 'Everything', model: 'Everything', isMain: true}),
      Ember.Object.create({title: 'Todos', model: 'Todo', isMain: false}),
      Ember.Object.create({title: 'Meetings', model: 'Meeting', isMain: false}), 
      Ember.Object.create({title: 'Phone Call', model: 'PhoneCall', isMain: false}),
      Ember.Object.create({title: 'Deals', model: 'Deal', isMain: false}),
      Ember.Object.create({title: 'Messages', model: 'Message', isMain: false}),
      Ember.Object.create({title: 'Discussions', model: 'Discussion', isMain: false}), 
      Ember.Object.create({title: 'Activity', model: 'Activity', isMain: true}), 
      Ember.Object.create({title: 'Pipeline', model: 'Pipeline', isMain: true})
    ]
  });
  
});