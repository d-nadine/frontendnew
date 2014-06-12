require 'models/email_props_mixin'

Radium.Email = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,
  Radium.EmailPropertiesMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  toContacts: DS.hasMany('Radium.Contact')
  toUsers: DS.hasMany('Radium.User')
  ccContacts: DS.hasMany('Radium.Contact')
  ccUsers: DS.hasMany('Radium.User')
  bccContacts: DS.hasMany('Radium.Contact')
  bccUsers: DS.hasMany('Radium.User')
  replies: DS.hasMany('Radium.Email', inverse: null)

  subject: DS.attr('string')
  message: DS.attr('string')
  html: DS.attr('string')
  read: DS.attr('boolean')
  sentAt: DS.attr('datetime')
  isRead: DS.attr('boolean')
  isPersonal: DS.attr('boolean')
  isDraft: DS.attr('boolean')
  name: Ember.computed.alias 'subject'
  sendTime: DS.attr('datetime')
  checkForResponse: DS.attr('datetime')

  threadCount: DS.attr('number')

  displayName: Ember.computed 'subject', ->
    return @get('subject') if @get('subject.length')

    return "(no subject)"

  notifications: DS.hasMany('Radium.Notification', inverse: '_referenceEmail')

  deal: DS.belongsTo('Radium.Deal')
  repliedTo: DS.belongsTo('Radium.Email')

  isScheduled: Ember.computed 'isDraft', 'sendTime', ->
    @get('isDraft') && @get('sendTime')

  sender: Ember.computed '_senderUser', '_senderContact', ->
    @get('_senderUser') ||
    @get('_senderContact')

  _senderUser: DS.belongsTo('Radium.User')
  _senderContact: DS.belongsTo('Radium.Contact')

  senderArray: Ember.computed 'sender', ->
    Ember.ArrayProxy.create
      content: [ @get('sender') ]

  toList: Radium.computed.aggregate('toUsers', 'toContacts')
  ccList: Radium.computed.aggregate('ccUsers', 'ccContacts')
  bccList: Radium.computed.aggregate('bccUsers', 'bccContacts')

  to: DS.attr('array')
  cc: DS.attr('array')
  bcc: DS.attr('array')

  isPublic: Ember.computed.not 'isPersonal'

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  people: Radium.computed.aggregate('toList','ccList', 'senderArray')
  recipients: Radium.computed.aggregate('toList','ccList')

  time: Ember.computed 'sentAt', 'updatedAt', ->
    @get('sentAt') || @get('updatedAt')

  clearRelationships: ->
    activities = []

    Radium.Activity.all().toArray().forEach((activity) =>
      if activity.get('meta.emailId')
        if(activity.get('meta.emailId').toString() == @get('id').toString() || activity.get('reference') == this)
          activities.push activity
    )

    activities.forEach (activity) =>
      activity.deleteRecord()

    @get('notifications').compact().forEach (notification) =>
      notification.deleteRecord()
