define('models/phonenumber', function(require) {
  require('ember');
  require('data');
  
  Radium.PhoneNumber = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string'),
  });
  
});