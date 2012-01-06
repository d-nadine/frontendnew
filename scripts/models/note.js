define('models/note', function(require) {
  require('ember');
  require('data');
  
  Radium.Note = DS.Model.extend({
    text: DS.attr('string')
  });
  
});