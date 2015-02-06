Radium.BulkEmailJob = Radium.Model.extend Radium.BulkActionProperties,
  Radium.AttachmentsMixin,

  subject: DS.attr('string')
  message: DS.attr('string')
  isDraft: DS.attr('boolean')
  sendTime: DS.attr('datetime')

  sender: DS.belongsTo('Radium.User')

  checkForResponse: DS.attr('datetime')

  isScheduled: Ember.computed 'isDraft', 'sendTime', ->
    @get('isDraft') && @get('sendTime')
