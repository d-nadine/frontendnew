Radium.contactsController = Ember.ArrayProxy.create({
  content: [],
  /**
    @binding {content.status}
    @return {Ember.Array} Filtered leads
  */
  leads: function() {
    return this.filterProperty('status', 'lead');
  }.property('@each.status').cacheable(),
  /**
    @binding {content.status}
    @return {Ember.Array} Filtered prospects
  */
  prospects: function() {
    return this.filterProperty('status', 'prospect');
  }.property('@each.status').cacheable(),
  /**
    @binding {content.status}
    @return {Ember.Array} Filtered opportunities
  */
  opportunities: function() {
    return this.filterProperty('status', 'opportunity');
  }.property('@each.status').cacheable(),

  /**
    @binding {content.status}
    @return {Ember.Array} Filtered customers
  */
  customers: function() {
    return this.filterProperty('status', 'customer');
  }.property('@each.status').cacheable(),

  /**
    @binding {content.status}
    @return {Ember.Array} Filtered dead ends
  */

  deadEnds: function() {
    return this.filterProperty('status', 'dead_end');
  }.property('@each.status').cacheable(),

  usersContactInfo: function() {
    return this.map(function(item) {
      return {
        label: item.get('name'), 
        value: item.get('id'),
        email: item.get('email'),
        phone: item.get('phone')
      };
    });
  }.property('@each.name').cacheable(),

  /**
    An array of objects for simple, name-only autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  contactNames: function() {
    return this.map(function(item) {
      return {label: item.get('name'), value: item.get('id')};
    });
  }.property('@each.name').cacheable(),

  /**
    An array of objects for emails, sms, etc for autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  contactsContactInfo: function() {
    return this.map(function(item) {
      return {
        label: item.get('name'), 
        value: item.get('id'),
        email: item.get('email'),
        phone: item.get('phone')
      };
    });
  }.property('@each.name').cacheable(),

  fetchContacts: function() {
    var self = this,
        content = Radium.store.findAll(Radium.Contact);
    this.set('content', content);
  },

  findContact: function(id) {
    return this.get('content').find(function(item) {
      return item.get('id') === id;
    });
  },

  // Contacts Page Filters
  filterTypes: [
    {
      title: 'Everything', 
      shortname: 'everything', 
      hasForm: false
    },
    {
      title: 'Contacts', 
      shortname: 'contacts', 
      formViewClass: 'Contact',
      hasForm: true
    },
    {
      title: 'Companies', 
      shortname: 'meeting', 
      formViewClass: 'Group',
      hasForm: true
    }, 
    {
      title: 'Leads', 
      shortname: 'leads', 
      hasForm: false
    },
    {
      title: 'Prospects', 
      shortname: 'Prospects', 
      hasForm: false
    },
    {
      title: 'Opportunities', 
      shortname: 'Opportunities',
      hasForm: false
    },
    {
      title: 'Customers', 
      shortname: 'Customers', 
      hasForm: false
    },
    {
      title: 'Dead Ends', 
      shortname: 'deadends', 
      hasForm: false
    },
    {
      title: 'Unassigned', 
      shortname: 'Unassigned', 
      hasForm: false
    },
    {
      title: 'No Upcoming Tasks', 
      shortname: 'notasks', 
      hasForm: false
    }
  ],

  /**
    Return all contacts selected on Contacts page.
  */
  selectedContacts: function() {
    return this.filterProperty('isSelected', true);
  }.property('@each.isSelected').cacheable()
});