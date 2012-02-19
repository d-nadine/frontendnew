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
    Radium.store.loadMany(Radium.Contact, Radium.Contact.FIXTURES);
    var self = this,
        content = Radium.store.findAll(Radium.Contact);
    this.set('content', content);
  },
  findContact: function(id) {
    return this.get('content').find(function(item) {
      return item.get('id') === id;
    });
  }
});