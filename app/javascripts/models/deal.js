Radium.Deal = Radium.Core.extend({
  type: 'deal',
  description: DS.attr('string'),
  closeBy: DS.attr('date', {
    key: 'close_by'
  }),
  // Can be `pending`, `closed`, `paid`, `rejected`
  state: DS.attr('dealState'),
  isPublic: DS.attr('boolean', {
    key: 'public'
  }),
  lineItems: DS.hasMany('Radium.LineItem', {
    embedded: true,
    key: 'line_items'
  }),
  contact: DS.belongsTo('Radium.Contact'),
  user: DS.belongsTo('Radium.User', {key: 'user'}),
  todos: DS.hasMany('Radium.Todo'),
  comments: DS.hasMany('Radium.Comment'),
  products: DS.hasMany('Radium.Product'),
  activities: DS.hasMany('Radium.Activity'),
  overdue: DS.attr('boolean'),
  /**
    Checks to see if the Deal has passed it's close by date.
    @return {Boolean}
  */
  isOverdue: function() {
    var d = new Date().getTime(),
        closeBy = new Date(this.get('closeBy')).getTime();
    return (closeBy <= d) ? true : false;
  }.property('closeBy').cacheable(),

  /**
    Calculate the total price from all the embedded line items
    @return {Number}
  */
  dealTotal: function() {
    var total = 0;
    this.get('lineItems').forEach(function(item) {
      return total += parseInt(item.get('price'));
    });
    return total;
  }.property('lineItems').cacheable()
});