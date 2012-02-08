define('views/forms/autocomplete', function(require) {
  
  var Radium = require('radium');

  Radium.AutocompleteTextField = Ember.TextField.extend(JQ.Widget, {
    uiType: 'autocomplete',
    uiOptions: ['source'],
    uiEvents: ['select', 'focus']
  });
  return Radium;
});