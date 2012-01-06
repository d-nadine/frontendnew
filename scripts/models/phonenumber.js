define('models/phonenumber', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.PhoneNumber = Radium.Core.extend({
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string'),
  });
  
});