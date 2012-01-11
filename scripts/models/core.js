/**
  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`
  
*/

define('models/radium', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Core = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date')
  });
  
  return Radium;
});