define(function(require) {
  var Radium = require('core/radium'),
      Person = require('models/person');
      
  Radium.peopleController = Ember.ArrayProxy.create({
    content: [],
    createPerson: function() {
      var person = Person.create({firstName: 'Joshua', lastName: 'Jones'});    
      this.pushObject(person);
    }
  });
  
  return Radium.peopleController;
  
});