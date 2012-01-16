define('models/deal', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Deal = Radium.Core.extend({
    description: DS.attr('string'),
    close_by: DS.attr('date'),
    state: DS.attr('string'),
    is_public: DS.attr('boolean'),
    line_items: DS.hasMany('Radium.LineItem', {embedded: true}),
    contact: DS.hasOne('Radium.Contact'),
    user: DS.hasOne('Radium.User'),
    todos: DS.hasMany('Radium.Todo'),
    comments: DS.hasMany('Radium.Comment'),
    products: DS.hasMany('Radium.Product'),
    activities: DS.hasMany('Radium.Activity'),

    isOverdue: function() {
      console.log(this.get('close_by'));
      // return (this.get('close_by'))
    }.property('close_by').cacheable()
  });
  
  return Radium;
});