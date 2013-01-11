Radium.Email = Radium.Core.extend Radium.CommentsMixin,
  to: DS.attr('array')
  from: DS.attr('array')
  subject: DS.attr('string')
  html: DS.attr('string')
  sender: Radium.polymorphicAttribute()
  read: DS.attr('boolean')
  isPublic: DS.attr('boolean')

  message: DS.attr('string')
  sentAt: DS.attr('date')

  attachments: DS.hasMany('Radium.Attachment')

  hasAttachments: (->
    true
  ).property('attachments.length')

  user: DS.belongsTo('Radium.User', polymorphicFor: 'sender')
  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'sender')
  todos: DS.hasMany('Radium.Todo', inverse: 'email')
