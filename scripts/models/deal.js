define('models/deal', function(require) {
  require('ember');
  require('data');
  
  Radium.Deal = DS.Model.extend({
    created_at: DS.attr('string'),
    updated_at: DS.attr('string'),
    description: DS.attr('string'),
    close_by: DS.attr('date'),
    state: DS.attr('string'),
    ispublic: DS.attr('boolean')
  });
  
});