Radium.Email = Radium.Core.extend Radium.CommentsMixin,
  to: DS.attr('array')
  from: DS.attr('array')
  subject: DS.attr('string')
  html: DS.attr('string')
  sender: Radium.polymorphicAttribute()

  message: DS.attr('string')
  sentAt: DS.attr('date')

  associatedContacts: Radium.defineFeedAssociation(Radium.Contact, 'sender')

  user: DS.belongsTo('Radium.User', polymorphicFor: 'sender')
  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'sender')
  todos: DS.hasMany('Radium.Todo', inverse: 'email')
