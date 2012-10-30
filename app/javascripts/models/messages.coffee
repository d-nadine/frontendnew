Radium.Message = Radium.Core.extend
  message: DS.attr('string')
  sentAt: DS.attr('date')
  type: DS.attr('string')
  user: DS.belongsTo('Radium.User')
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  attachments: DS.hasMany('Radium.Attachment')
  todos: DS.hasMany('Radium.Todo')
