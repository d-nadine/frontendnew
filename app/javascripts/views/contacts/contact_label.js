Radium.ContactLabelView = Radium.LabelView.extend({
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
        status = this.get('label'),
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
  }.property('label', 'contact').cacheable(),

  template: Ember.Handlebars.compile('{{#if status}}{{statusString}}{{/if}}')
});