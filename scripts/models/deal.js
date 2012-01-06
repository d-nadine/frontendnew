define('models/deal', function(require) {
  require('ember');
  require('data');
  
  Radium.Deal = DS.Model.extend({
    created_at: DS.attr('string'),
    updated_at: DS.attr('string'),
    description: DS.attr('string'),
    close_by: DS.attr('date'),
    state: DS.attr('string'),
    is_public: DS.attr('boolean'),
    line_items: DS.hasMany(Radium.LineItem, {embedded: true}),
    contact: DS.hasMany(Radium.Contact),
    user: DS.hasMany(Radium.User),
    todos: DS.hasMany(Radium.Todo),
    comments: DS.hasMany(Radium.Comment),
    products: DS.hasMany(Radium.Product),
    activities: DS.hasMany(Radium.Activity)
  });
  
});