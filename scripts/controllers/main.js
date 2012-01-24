define(function(require) {
  require('ember');
  var Radium = require('radium');
  
  require('./app');
  require('./users');
  require('./contacts');
  require('./resources');
  
  return Radium;
});