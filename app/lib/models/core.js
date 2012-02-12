/**
  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`
  
*/

Radium.Core = DS.Model.extend({
  createdAt: DS.attr('date', {
    key: 'created_at'
  }),
  updatedAt: DS.attr('date', {
    key: 'updated_at'
  })
});