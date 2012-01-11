define('models/lineitem', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.LineItem = DS.Model.extend({
    name: DS.attr('string'),
    quantity: DS.attr('integer'),
    price: DS.attr('integer'),
    currency: DS.attr('string'),
    product: DS.attr('integer')
  });
  
  return Radium;
});