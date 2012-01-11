define(function(require) {
  require('ember');
  require('data');
  var Radium = require('radium');
  
  require('models/user');
  require('models/contact');
  
  return Radium;
});