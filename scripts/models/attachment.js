define('models/attachment', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Attachment = Radium.Core.extend();
  
  return Radium;
});