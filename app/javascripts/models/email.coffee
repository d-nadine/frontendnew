Radium.Email = Radium.Core.extend Radium.CommentsMixin,
  subject: DS.attr('string')
  html: DS.attr('string')
  read: DS.attr('boolean')
  isPublic: DS.attr('boolean')
  message: DS.attr('string')
  sentAt: DS.attr('date')

  sender: DS.attr('object')

  attachments: DS.hasMany('Radium.Attachment')

  hasAttachments: (->
    true
  ).property('attachments.length')
