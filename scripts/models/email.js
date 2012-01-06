define('models/email', function(require) {
  require('ember');
  require('data');
  
  Radium.Email = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string')
  });
  
});