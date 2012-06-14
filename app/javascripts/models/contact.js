/**
  @extends {Class} Person
*/

Radium.Contact = Radium.Person.extend({
  namingConvention: {
    keyToJSONKey: function(key) {
      // TODO: Strip off `is` from the front. Example: `isHipster` becomes `hipster`
      return Ember.String.decamelize(key);
    },
    foreignKey: function(key) {
      if (key !== 'user') {
        return Ember.String.decamelize(key) + '_attributes';
      } else {
        return key;
      }
      
    }
  },

  contactedAt: DS.attr('date', {
    key: 'contacted_at'
  }),
  becameLeadAt: DS.attr('date', {
    key: 'became_lead_at'
  }),
  becameProspectAt: DS.attr('date', {
    key: 'became_prospect_at'
  }),
  becameOpportunityAt: DS.attr('date', {
    key: 'became_opportunity_at'
  }),
  becameCustomerAt: DS.attr('date', {
    key: 'became_customer_at'
  }),
  becameDeadEndAt: DS.attr('date', {
    key: 'became_dead_end_at'
  }),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),
  status: DS.attr('string'),
  addresses: DS.hasMany('Radium.Address', {embedded: true}),
  phoneNumbers: DS.hasMany('Radium.PhoneNumber', {
    embedded: true,
    key: 'phone_numbers'
  }),
  emailAddresses: DS.hasMany('Radium.EmailAddress', {
    embedded: true,
    key: 'email_addresses'
  }),
  fields: DS.hasMany('Radium.Field', {embedded: true}),
  source: DS.attr('string'),
  user: DS.belongsTo('Radium.User'),
  // For checkboxes
  isSelected: false,

  url: function() {
    return "/contacts/%@".fmt(this.get('id'));
  }.property('id').cacheable(),

  // Filter properties
  assigned: function() {
    return (this.get('user')) ? true : false;
  }.property('user').cacheable(),
  
  noUpcomingTasks: function() {
    return (this.get('todos')) ? true : false;
  }.property('todos').cacheable(),

  firstLetter: function() {
    if (this.get('name')) {
      return this.get('name').charAt(0).toUpperCase();  
    } else {
      return "";
    }
  }.property('name').cacheable(),

  displayName: DS.attr('string', {key: 'display_name'}),
  feedDisplayName: function() {
    return this.get('displayName') || "Contact %@".fmt(this.get('id'));
  }.property('displayName'),

  feed: null,

  user_id: DS.attr('number'),

  canEdit: function() {
    var userId = this.getPath('user.id'),
        loggedInUserId = Radium.usersController.getPath('loggedInUser.id');
    return userId === loggedInUserId;
  }.property('user').cacheable(),

  // HAX for Data
  email_addresses_attributes: DS.attr('array'),
  phone_numbers_attributes: DS.attr('array'),
  addresses_attributes: DS.attr('array'),
  fields_attributes: DS.attr('array'),
  notes_attributes: DS.attr('array')
});