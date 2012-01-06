define('models/address', function(require) {
  require('ember');
  require('data');
  
  Radium.Address = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    name: DS.attr('string'),
    street: DS.attr('string'),
    state: DS.attr('string'),
    country: DS.attr('string'),
    zip_code: DS.attr('integer'),
    time_zone: DS.attr('string')
  });
  
});