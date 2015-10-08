Radium.Template = Radium.Model.extend Radium.AttachmentsMixin,
  Radium.TimestampsMixin,

  subject: DS.attr('string')
  html: DS.attr('string')
  sentCount: DS.attr('number')
  lastUsed: DS.attr('datetime')

  time: Ember.computed.oneWay 'createdAt'
