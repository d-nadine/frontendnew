Radium.contactsController = Ember.ArrayProxy.create({
  content: [],
  selectedFilter: null,
  // _cache: [],
  // changeFilter: function() {
  //   var filter = this.get('selectedFilter'),
  //       content = this.get('content');

  //   console.log('filter', filter);

  //   if (filter) {
  //     var test = content.filter(function(item) {
  //       if (item.get('status') === filter) {
  //         return true;
  //       }
  //     });
  //     // this.set('_cache', content);
  //     // this.set('content', test);
  //   } else {
  //     this.set('content', cache);
  //   }

  // }.observes('selectedFilter'),

  setFilter: function(filterType) {
    
    var content = this.get('content'),
        _cache = this.get('_cache');

    if (filterType) {
      
    }

    var test = content.filter(function(item) {
      if (filterType === 'unassigned') {
        if (item.get('noUpcomingTasks') === true) {
          return true;
        }
      }

      if (filterType === 'no_tasks') {
        if (item.get('assigned') === false) {
          return true;
        }
      }

      if (item.get('status') === filterType) {
        return true;
      }

    });
  },

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
      title: 'Contacts', 
      shortname: 'contact', 
      formViewClass: 'Contact',
      hasForm: true
    },
    {
      title: 'Companies', 
      shortname: 'company', 
      formViewClass: 'Group',
      hasForm: true
    }, 
    {
      title: 'Leads', 
      shortname: 'lead', 
      hasForm: false
    },
    {
      title: 'Prospects', 
      shortname: 'prospect', 
      hasForm: false
    },
    {
      title: 'Opportunities', 
      shortname: 'opportunity',
      hasForm: false
    },
    {
      title: 'Customers', 
      shortname: 'customer', 
      hasForm: false
    },
    {
      title: 'Dead Ends', 
      shortname: 'dead_end', 
      hasForm: false
    },
    {
      title: 'Unassigned', 
      shortname: 'unassigned', 
      hasForm: false
    },
    {
      title: 'No Upcoming Tasks', 
      shortname: 'no_tasks', 
      hasForm: false
    }
  ],

  /**
    Return all contacts selected on Contacts page.
    @binding {content.isSelected}
  */
  selectedContacts: function() {
    return this.filterProperty('isSelected', true);
  }.property('@each.isSelected').cacheable(),

  /**
    Return the selected contacts names
    @binding {content.isSelected}
  */
  selectedContactsNames: function() {
    return this.filterProperty('isSelected', true).getEach('name');
  }.property('@each.isSelected').cacheable(),
});