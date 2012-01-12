/**
  @extends {Class} Person
*/
define('models/user', function(require) {
  require('ember');
  require('data');
  var Radium = require('radium');
  require('models/person');
  require('models/contact');

  Radium.User = Radium.Person.extend({
    email: DS.attr('string'),
    phone: DS.attr('string'),
    account: DS.attr('integer'),
    contacts: DS.hasMany('Radium.Contact'),
    following: DS.hasMany('Radium.User'),
    
    // States
    didUpdate: function() {
      console.log('updating');
    }
  });
  
  return Radium;
});