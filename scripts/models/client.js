define(function(require) {
  var Person = require('./person');
  var Client = Person.extend({
    firstName: null,
    lastName: null,
    fullName: function() {
      return this.get('firstName') + ' ' + this.get('lastName');
    }.property('firstName', 'lastName')
  });

  return Client;
  
});