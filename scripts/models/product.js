define('models/product', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Product = Radium.Core.extend({
    
  });
  
  return Radium;
  
});