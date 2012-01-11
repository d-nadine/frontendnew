define('models/address', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Address = Radium.Core.extend({
    name: DS.attr('string'),
    street: DS.attr('string'),
    state: DS.attr('string'),
    country: DS.attr('string'),
    zip_code: DS.attr('integer'),
    time_zone: DS.attr('string')
  });
  
  return Radium;
});