define('models/customfield', function(require) {
  require('ember');
  require('data');
  
  Radium.Field = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string'),
    // TODO: Add model validation, kind can only be one of: email_address, phone_number, url, other
    kind: DS.attr('string')
  });
  
});