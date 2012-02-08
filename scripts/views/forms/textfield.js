define('views/forms/textfield', function(require) {
  
  var Radium = require('radium');

  Radium.TextField = Ember.TextField.extend({
    attributeBindings: ['type', 'value', 'name', 'placeholder'],
  });

  return Radium;
});