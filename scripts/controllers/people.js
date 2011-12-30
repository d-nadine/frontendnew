define(function(require) {
  var Radium = require('radium'),
      Person = require('models/person');

  Radium.peopleController = Ember.ArrayController.create({
    content: [],
    createPerson: function() {
      var person = Person.create({firstName: 'Joshua', lastName: 'Jones'});    
      this.pushObject(person);
    }
  });  
});