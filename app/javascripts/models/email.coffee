Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  todos: DS.hasMany('Radium.Todo')

  subject: DS.attr('string')
  message: DS.attr('string')
  read: DS.attr('boolean')
  isPublic: DS.attr('boolean')
  sentAt: DS.attr('datetime')

  sender: DS.attr('object')
  to: DS.attr('array')
  cc: DS.attr('array')
  bcc: DS.attr('array')
