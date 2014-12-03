Radium.BulkEmailJob = Radium.Model.extend Radium.BulkActionProperties,
  Radium.AttachmentsMixin,

  subject: DS.attr('string')
  message: DS.attr('string')
  body: DS.attr('string')
  isDraft: DS.attr('boolean')
  sendTime: DS.attr('datetime')

  sender: DS.belongsTo('Radium.User')

  isScheduled: Ember.computed 'isDraft', 'sendTime', ->
    @get('isDraft') && @get('sendTime')
