Radium.BulkEmailJob = Radium.Model.extend Radium.BulkActionProperties,
  Radium.AttachmentsMixin,

  subject: DS.attr('string')
  html: DS.attr('string')
  isDraft: DS.attr('boolean')
  sendTime: DS.attr('datetime')

  sender: DS.belongsTo('Radium.User')

  checkForResponse: DS.attr('datetime')

  lists: DS.attr('array')

  isScheduled: Ember.computed 'isDraft', 'sendTime', ->
    @get('isDraft') && @get('sendTime')
