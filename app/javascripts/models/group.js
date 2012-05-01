Radium.Group = Radium.Core.extend({
  name: DS.attr('string'),
  email: DS.attr('string'),
  phone: DS.attr('string'),
  is_public: DS.attr('boolean'),
  primaryContact: DS.hasOne('Radium.Contact', {
    key: 'primary_contact'
  }),
  fields: DS.hasMany('Radium.Field'),
  todos: DS.hasMany('Radium.Todo'),
  deals: DS.hasMany('Radium.Deal'),
  messages: DS.hasMany('Radium.Message'),
  notes: DS.hasMany('Radium.Note'),
  phoneCalls: DS.hasMany('Radium.PhoneCall', {
    key: 'phone_calls'
  }),
  meetings: DS.hasMany('Radium.Meeting'),
  campaigns: DS.hasMany('Radium.Campaign'),
  users: DS.hasMany('Radium.User'),
  contacts: DS.hasMany('Radium.Contact'),
  activities: DS.hasMany('Radium.Activity'),
  user: DS.hasOne('Radium.User'),

  contact_ids: DS.attr('array')
});