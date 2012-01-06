/**
  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`
  
*/

define('models/radium', function(require) {
  
  Radium.Core = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date')
  });
  
});