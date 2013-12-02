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

  sender: ( ->
    @get('_senderUser') ||
    @get('_senderContact')
  ).property('_senderUser', '_senderContact')

  _senderUser: DS.belongsTo('Radium.User')
  _senderContact: DS.belongsTo('Radium.Contact')

  senderArray: (->
    Ember.ArrayProxy.create
      content: [ @get('sender') ]
  ).property('sender')

  toList: Radium.computed.aggregate('toUsers', 'toContacts')
  ccList: Radium.computed.aggregate('ccUsers', 'ccContacts')
  bccList: Radium.computed.aggregate('bccUsers', 'bccContacts')

  to: DS.attr('array')
  cc: DS.attr('array')
  bcc: DS.attr('array')
  attachedFiles: DS.attr('array')

  hasLead: ( ->
    sender = @get('sender')
    return unless sender
    sender.constructor is Radium.Contact && sender.get('isLead')
  ).property('sender')

  isPublic: Ember.computed.not 'isPersonal'

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  people: Radium.computed.aggregate('toList','ccList', 'senderArray')
  recipients: Radium.computed.aggregate('toList','ccList')

  time: Ember.computed.alias 'sentAt'
