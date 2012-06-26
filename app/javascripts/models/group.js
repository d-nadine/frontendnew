Radium.Group = Radium.Core.extend({
  type: 'group',
  name: DS.attr('string'),
  email: DS.attr('string'),
  phone: DS.attr('string'),
  is_public: DS.attr('boolean'),
  primaryContact: DS.belongsTo('Radium.Contact', {
    key: 'primary_contact'
  }),
  fields: DS.hasMany('Radium.Field'),
  todos: DS.hasMany('Radium.Todo'),
  deals: DS.hasMany('Radium.Deal'),
  messages: DS.hasMany('Radium.Message'),
  notes: DS.hasMany('Radium.Note', {embedded: true}),
  phoneCalls: DS.hasMany('Radium.PhoneCall', {
    key: 'phone_calls'
  }),
  meetings: DS.hasMany('Radium.Meeting'),
  campaigns: DS.hasMany('Radium.Campaign'),
  users: DS.hasMany('Radium.User'),
  contacts: DS.hasMany('Radium.Contact'),
  activities: DS.hasMany('Radium.Activity'),
  user: DS.belongsTo('Radium.User', {key: 'user'}),

  contact_ids: DS.attr('array')
});
