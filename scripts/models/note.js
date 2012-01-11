define('models/note', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Note = Radium.Core.extend({
    text: DS.attr('string')
  });
  
  return Radium
});