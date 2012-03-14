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
    return (this.get('status') === 'Lead') ? true : false;
  }.property('status').cacheable(),
  isProspect: function() {
    return (this.get('status') === 'Prospect') ? true : false;
  }.property('status').cacheable(),
  isOpportunity: function() {
    return (this.get('status') === 'Opportunity') ? true : false;
  }.property('status').cacheable(),
  isClient: function() {
    return (this.get('status') === 'Client') ? true : false;
  }.property('status').cacheable(),
  isDeadEnd: function() {
    return (this.get('status') === 'Dead End') ? true : false;
  }.property('status').cacheable(),

  template: Ember.Handlebars.compile('{{status}}')
});