define('models/deal', function(require) {
  require('ember');
  require('data');
  
  Radium.Deal = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    description: DS.attr('string'),
    close_by: DS.attr('date'),
    state: DS.attr('string'),
    public: DS.attr('boolean')
  });
  
});