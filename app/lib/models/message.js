Radium.Message = Radium.Core.extend({
  message: DS.attr('string'),
  sentAt: DS.attr('date', {
    key: 'sent_at'
  }),
  type: DS.attr('string'),
  users: DS.hasMany('Radium.User'),
  contacts: DS.hasMany('Radium.Contact'),
  comments: DS.hasMany('Radium.Comment'),
  attachments: DS.hasMany('Radium.Attachment'),
  todos: DS.hasMany('Radium.Todo')
});