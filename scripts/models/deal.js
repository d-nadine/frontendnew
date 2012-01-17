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
    
    /**
      Checks to see if the Deal has passed it's close by date.
      @return {Boolean}
    */
    isOverdue: function() {
      var d = new Date().getTime(),
          closeBy = new Date(this.get('close_by')).getTime();
      return (closeBy <= d) ? true : false;
    }.property('close_by').cacheable(),

    dealTotal: function() {
      var total = 0;
      this.get('line_items').forEach(function(item) {
        return total += parseInt(item.get('price'));
      });
      return total;
    }.property('@each.line_items').cacheable()
  });
  
  return Radium;
});