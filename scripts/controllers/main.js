define(function(require) {
  require('ember');
  var Radium = require('radium');
  
  require('controllers/app');
  require('controllers/users');
  require('controllers/contacts');
  require('controllers/resources');
  
  return Radium;
});