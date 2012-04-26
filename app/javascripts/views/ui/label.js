Radium.LabelView = Ember.View.extend({
  tagName: 'span',
  classNames: ['label'],
  classNameBindings: [
    'isLead:label-info',
    'isProspect:label-warning',
    'isOpportunity:label-inverse',
    'isCustomer:label-success',
    'isDeadEnd:label-important'
  ],
  // Status type bindings
  isLead: function() {
    return (this.get('label') === 'lead') ? true : false;
  }.property('label').cacheable(),
  isProspect: function() {
    return (this.get('label') === 'prospect') ? true : false;
  }.property('label').cacheable(), 
  isOpportunity: function() {
    return (this.get('label') === 'opportunity') ? true : false;
  }.property('label').cacheable(),
  isCustomer: function() {
    return (this.get('label') === 'customer') ? true : false;
  }.property('label').cacheable(),
  isDeadEnd: function() {
    return (this.get('label') === 'dead_end') ? true : false;
  }.property('label').cacheable(),

  template: Ember.Handlebars.compile('{{label}}')
});