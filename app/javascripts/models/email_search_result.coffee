Radium.EmailSearchResult = Radium.Model.extend Radium.TimestampsMixin,
  subject: DS.attr('string')
  folder: DS.attr('string')
  sentAt: DS.attr('datetime')

  subjectHighlights: DS.attr('array', defaultValue: [])
  bodyHighlights: DS.attr('array', defaultValue: [])

  email: DS.belongsTo('Radium.Email')

  sender: ( ->
    @get('_senderUser') ||
    @get('_senderContact')
  ).property('_senderUser', '_senderContact')
