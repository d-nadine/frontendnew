define(function(require) {
  var Radium = require('core/radium');

  Radium.Person = Ember.Object.extend({
    firstName: null,
    lastName: null,
    fullName: function() {
      return this.get('firstName') + ' ' + this.get('lastName');
    }.property('firstName', 'lastName')
  });
  
  return Radium.Person;
  
});