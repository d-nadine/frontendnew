define('models/customfield', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Field = Radium.Core.extend({
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string'),
    // TODO: Add model validation, kind can only be one of: email_address, phone_number, url, other
    kind: DS.attr('string')
  });
  
});