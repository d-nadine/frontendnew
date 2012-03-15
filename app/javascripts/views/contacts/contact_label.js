Radium.ContactLabelView = Ember.View.extend({
  tagName: 'span',
  classNames: ['label'],
  classNameBindings: [
    'isLead:label-info',
    'isProspect:label-warning',
    'isOpportunity:label-info',
    'isCustomer:label-success',
    'isDeadEnd:label-important'
  ],

  key: {
    'lead': 'Lead',
    'prospect': 'Prospect',
    'opportunity': 'Opportunity',
    'customer': 'Customer',
    'dead_end': 'Dead End'
  },

  statusString: function() {
    var daysSinceAdded = "",
        key = this.get('key'),
        status = this.get('status'),
        sinceDate = this.getPath('contact.became'
                        + key[status].replace(' ', '')
                        + 'At');
    // Hold off till bindings are set up.
    // if (sinceDate) {
    //   var daysBetween = sinceDate.getDaysBetween(new Date());
    //   if (daysBetween !== 0) {
    //     daysSinceAdded = " for "+ daysBetween;

    //     if (daysBetween === 1) {
    //       daysSinceAdded += " day";
    //     } else {
    //       daysSinceAdded += " days";
    //     }
    //   }
    // }
    return key[status] + daysSinceAdded;
  }.property('status', 'contact').cacheable(),

  isLead: function() {
    return (this.get('status') === 'lead') ? true : false;
  }.property('status').cacheable(),
  isProspect: function() {
    return (this.get('status') === 'prospect') ? true : false;
  }.property('status').cacheable(),
  isOpportunity: function() {
    return (this.get('status') === 'opportunity') ? true : false;
  }.property('status').cacheable(),
  isCustomer: function() {
    return (this.get('status') === 'customer') ? true : false;
  }.property('status').cacheable(),
  isDeadEnd: function() {
    return (this.get('status') === 'dead_end') ? true : false;
  }.property('status').cacheable(),

  template: Ember.Handlebars.compile('{{statusString}}')
});