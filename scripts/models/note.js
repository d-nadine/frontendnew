define('models/note', function(require) {
  require('ember');
  require('data');
  require('./core');
  
  Radium.Note = Radium.Core.extend({
    text: DS.attr('string')
  });
  
});