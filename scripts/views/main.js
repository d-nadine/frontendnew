define(function(require) {
  require('ember');
  var Radium = require('radium');
  
  require('views/topbar');
  require('views/dashboard');  
  
  return Radium;
});