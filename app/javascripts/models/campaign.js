Radium.Campaign = Radium.Core.extend({
  type: 'campaign',
  name: DS.attr('string'),
  description: DS.attr('string'),
  endsAt: DS.attr('date', {
    key: 'ends_at'
  }),
  currency: DS.attr('string'),
  target: DS.attr('number'),
  user: DS.belongsTo('Radium.User', {key: 'user'}),
  is_public: DS.attr('boolean'),
  contacts: DS.hasMany('Radium.Contact'),
  todos: DS.hasMany('Radium.Todo'),
  deals: DS.hasMany('Radium.Deal'),
  phone_calls: DS.hasMany('Radium.PhoneCall'),
  messages: DS.hasMany('Radium.Message'),
  groups: DS.hasMany('Radium.Group'),
  products: DS.hasMany('Radium.Product'),
  users: DS.hasMany('Radium.User'),
  followers: DS.hasMany('Radium.User'),
  notes: DS.hasMany('Radium.Note'),
  meetings: DS.hasMany('Radium.Meeting'),
  activities: DS.hasMany('Radium.Activity'),

  url: function() {
    return '/campaigns/%@'.fmt(this.get('id'));
  }.property('id').cacheable(),

  totalContacts: function() {
    return this.getPath('data.contacts.length');
  }.property('contacts').cacheable(),

  totalUsers: function() {
    return this.getPath('data.users.length');
  }.property('users').cacheable(),

  contact_ids: function() {
    return this.get('contacts').getEach('id');
  }.property('contacts').cacheable()
});