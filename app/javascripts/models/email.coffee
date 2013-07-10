Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

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
  read: DS.attr('boolean')
  sentAt: DS.attr('datetime')
  isRead: DS.attr('boolean')
  isPersonal: DS.attr('boolean')

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
  ccList: Radium.computed.aggregate('ccUsers', 'ccUsers')
  bccList: Radium.computed.aggregate('bccUsers', 'bccContacts')

  to: DS.attr('array')
  cc: DS.attr('array')
  bcc: DS.attr('array')

  isPublic: Ember.computed.not 'isPersonal'

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  people: Radium.computed.aggregate('toList','ccList', 'senderArray')
  recipients: Radium.computed.aggregate('toList','ccList')

  isIncludedInConversation: (email) ->
    return true if email == this

    people = @get 'people'
    otherPeople = email.get 'people'

    return false if people.get('length') != otherPeople.get('length')

    otherPeople.every (person) ->
      people.contains person

  time: Ember.computed.alias 'sentAt'
