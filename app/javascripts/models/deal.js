Radium.Deal = Radium.Core.extend({
  isEditable: true,
  type: 'deal',
  name: DS.attr('string'),
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
  notes: DS.hasMany('Radium.Note', {embedded: true}),
  products: DS.hasMany('Radium.Product'),
  activities: DS.hasMany('Radium.Activity'),
  overdue: DS.attr('boolean'),
  line_item_attributes: DS.hasMany('Radium.LineItem', {
    embedded: true
  }),

  isPending: function() {
    return this.get('state') === 'pending';
  }.property('state'),

  isClosed: function() {
    return this.get('state') === 'closed';
  }.property('state'),

  isPaid: function() {
    return this.get('state') === 'paid';
  }.property('state'),

  isRejected: function() {
    return this.get('state') === 'rejected';
  }.property('state'),
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