Radium.Notification = DS.Model.extend({
  createdAt: DS.attr('datetime', {
    key: 'created_at'
  }),
  updatedAt: DS.attr('datetime', {
    key: 'updated_at'
  }),
  tag: DS.attr('string'),
  todo: DS.belongsTo('Radium.Todo', {
    embedded: true
  }),
  meeting: DS.belongsTo('Radium.Meeting', {
    embedded: true
  }),
  campaign: DS.belongsTo('Radium.Campaign', {
    embedded: true
  }),
  group: DS.belongsTo('Radium.Group', {
    embedded: true
  }),
  contact: DS.belongsTo('Radium.Contact', {
    embedded: true,
    key: 'contact'
  }),
  invitation: DS.belongsTo('Radium.Invitation', {
    key: 'invitation',
    embedded: true
  }),
  callList: DS.belongsTo('Radium.CallList', {
    key: 'call_list', 
    embedded: true
  }),
  phoneCall: DS.belongsTo('Radium.PhoneCall', {
    key: 'phone_call', 
    embedded: true
  }),
  email: DS.belongsTo('Radium.Email', {
    embedded: true
  }),
  sms: DS.belongsTo('Radium.Sms', {
    embedded: true
  }),
  deal: DS.belongsTo('Radium.Deal', {
    embedded: true
  })
});
