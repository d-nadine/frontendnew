Radium.contactsController = Ember.ArrayProxy.extend({
   bootStarpLoaded: function(){
    var contacts = Radium.getPath('appController.contacts');
    
    Radium.store.loadMany(Radium.Contact, contacts);

    this.set('content', Radium.store.findMany(Radium.Contact, contacts.mapProperty('id').uniq()));
  }.observes('Radium.appController.contacts'),

  isAllContactsLoaded: function() {
    return (this.get('totalPagesLoaded') === this.get('totalPages')) ? true : false;
  }.property('totalPagesLoaded', 'totalPages').cacheable(),

  recentlySearchedFor: function() {
    return this.filter(function(contact, idx) {
      if (contact.get('isRecentlySearchedFor') && idx <= 5) {
        return true;
      }
    });
  }.property('@each.isRecentlySearchedFor').cacheable(),

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

  /**
    @binding {content.user}
    @return {Ember.Array} Contacts without a user :'(
  */
  unassigned: function() {
    return this.filterProperty('user', null);
  }.property('@each.user').cacheable(),

  /**
    @binding {content.todos}
    @return {Ember.Array} Contacts with no upcoming todos
    TODO: Figure out how to acurately determine this
  */
  noUpcomingTasks: function() {
    return this.filter(function(item) {
      if (!item.getPath('data.todos.length')) {
        return true;
      }
    });
  }.property('@each.todos').cacheable(),

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

  // Simple array of names.
  names: function() {
    return this.getEach('name');
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

  contactNamesWithObject: function() {
    return this.map(function(item) {
      return {label: item.get('name'), contact: item};
    });
  }.property('@each.name').cacheable(),

  /**
    An array of objects for emails, sms, etc for autocomplete in forms.
    eg [{label: "Avon Barksdale", value: {userid}}]
    @return {Array} 
  */
  contactsContactInfo: function() {
    return this.map(function(item) {
      var name = item.get('name'),
          email = item.getPath('emailAddresses.firstObject.value');

      return {
        label: "%@ <%@>".fmt(name, email),
        value: email
      };
    });
  }.property('@each.name').cacheable(),

  emails: function() {
    return this.map(function(item) {
      var name = item.get('name'),
          email = item.getPath('emailAddresses.firstObject.value');

      return {
        label: "%@ <%@>".fmt(name, email),
        value: email,
        target: item
      };
    });
  }.property('@each.name').cacheable(),

  fetchContacts: function() {
    var self = this,
        content = Radium.store.find(Radium.Contact, {page: 'all'});
    this.set('content', content);
  },

  findContact: function(id) {
    return this.get('content').find(function(item) {
      return item.get('id') === id;
    });
  },

  /**
    Return all contacts selected on Contacts page.
    @binding {content.isSelected}
  */
  selectedContacts: function() {
    return this.filterProperty('isSelected', true);
  }.property('@each.isSelected').cacheable(),

  /**
    Return all contacts IDs selected on Contacts page.
    @binding {content.isSelected}
  */
  selectedContactsIds: function() {
    return this.get('selectedContacts').mapProperty('id');
  }.property('@each.isSelected').cacheable(),

  /**
    Return the selected contacts names
    @binding {content.isSelected}
  */
  selectedContactsNames: function() {
    return this.get('selectedContacts').getEach('name');
  }.property('selectedContacts').cacheable(),

  selectedContactsEmails: function() {
    var selectedContacts = this.get('selectedContacts'),
        emails = Ember.A([]);
    selectedContacts.forEach(function(item) {
      var email = item.getPath('emailAddresses.firstObject.value');
      emails.pushObject(email);
    });
    return emails;
  }.property('selectedContacts').cacheable(),

  selectedContactsPhoneNumbers: function() {
    var selectedContacts = this.get('selectedContacts'),
        phoneNumbers = Ember.A([]);
    selectedContacts.forEach(function(item) {
      var phone = item.getPath('phoneNumbers.firstObject.value');
      phoneNumbers.pushObject(phone);
    });
    return phoneNumbers;
  }.property('selectedContacts').cacheable(),

  clearSelected: function() {
    this.setEach('isSelected', false);
  },


  // Infinite scroll functions
  currentPage: 0,
  totalPages: 0,
  load: function() {
    var self = this,
        currentPage = this.get('currentPage'),
        totalPages = this.get('totalPages'),
        hasNoPages = currentPage === 0 && totalPages === 0,
        isNotAtEnd = currentPage !== totalPages;

    if (isNotAtEnd) {
      var contactsPage = Radium.store.find(Radium.Contact, {
            page: ++currentPage
          });
    }
  }
});
