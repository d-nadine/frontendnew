Radium.ContactLabelView = Ember.View.extend({
  tagName: 'span',
  classNames: ['label'],
  classNameBindings: [
    'isLead:label-info',
    'isProspect:label-warning',
    'isOpportunity:label-info',
    'isClient:label-success',
    'isDeadEnd:label-important'
  ],
  isLead: function() {
    return (this.get('status') === 'lead') ? true : false;
  }.property('status').cacheable(),
  isProspect: function() {
    return (this.get('status') === 'prospect') ? true : false;
  }.property('status').cacheable(),
  isOpportunity: function() {
    return (this.get('status') === 'opportunity') ? true : false;
  }.property('status').cacheable(),
  isClient: function() {
    return (this.get('status') === 'client') ? true : false;
  }.property('status').cacheable(),
  isDeadEnd: function() {
    return (this.get('status') === 'dead_end') ? true : false;
  }.property('status').cacheable(),

  template: Ember.Handlebars.compile('{{status}}')
});